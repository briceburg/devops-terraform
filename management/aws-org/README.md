# aws-org

Manages an AWS Organization including;
* accounts
* users
* permissions

> :bulb: skips [AFT](https://docs.aws.amazon.com/controltower/latest/userguide/taf-account-provisioning.html) / Control Tower in favor of pure Terraform approach.

Assumes [IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/organization-instances-identity-center.html) has been enabled in the [Org Management account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html).


## Accounts

Each account belongs to a **tier** (aka a parent OU), such as `prod`. A [SCP](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html) is in place that denies access from resources in one tier from accessing resources from another. This enhances security.

For instance, if there is a policy on a bucket living in an account under the `prod` tier that _explicitly_ allows reading from an IAM/ECS role that exists under the `notprod` tier, reads from that role will be _denied_ even through the policy gives them permission. Modifying the SCP to explicitly allow this behavior is needed as well.

For demonstration purposes, two tiers are created -- `prod` and `notprod`. Account names are prefixed with the tier they belong to, e.g. `prod-workloads` and `prod-logs` for the "workloads" and "logs" account. The following accounts are created following the [AWS Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/architecture.html);

```yaml
infrastructure:
  - network
  - shared-services
security:
  - logs
  - security-tooling
workloads:
  - sandbox
```

Modify [locals-accounts.tf](./local-accounts.tf) to suit your organization's needs and be sure to create [state buckets](../tfstate/) after the accounts have been provisioned.


### Discovery

After terraforming, the discovery module provides a manifest of accounts and other organization details to entities within the organization through a S3 bucket named `<org>-aws-org`. The accounts path is `/accounts.json`. Example;

```
aws s3 cp s3://iceburg-devops-aws-org/accounts.json - | jq
```

Terraform remote state and outputs can also be used to discover organization details.


## Usage

Terraform must have the ability to manage resources in the [Org Management account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html). 

I recommend the account name be <org>-management, e.g. `iceburg-management` for clarity.


### initial setup (bootstrapping)

Currently, named AWS profiles are used to manage resources in target accounts and access state. When first starting out, an administrative user with appropriate profiles must be created. **This user and permission set will only be used for interacting with the management account to create the initial tfstate bucket and accounts**. Recommended procedure; 

* Create `admin` _Group_ in IAM Identity Center.
* Create `breakglass` _User_ in IAM Identity Center. 
  * See [Admin User Example Image](docs/img/AdminUser.png)
  * Assign `breakglass` _User_ to `admin` _Group_.
* Create `AdministratorAccess` _Permission Set_ in IAM Identity Set and assign the eponymous AWS Managed Policy.
* Add the `AdministratorAccess` _Permission Set_ to the Management Account and select the `admin` _Group_.
  * See [Management Account Example Image](docs/img/ManagementAccount.png).
* Start an SSO session as this user and configure the `<org>-management/operate` profile;
  ```sh
  # configure a new session
  # enter the correct start_url and region
  # name the session <org>, e.g. 'iceburg'
  aws configure sso-session

  # login to the session
  aws sso login --sso-session <org>

  # configure the  profile
  # select management account and admin role
  # name the profile <org>-management/operate, e.g. 'iceburg-management/operate'
  aws configure sso
  ```
* Create the management tfstate bucket, following [management-state](../tfstate/README.md#usage) instructions.
* Modify the [config module variables](./modules/config/variables.tf) to provide _default values_ matching your organization.
* :tada: you can now run terraform in this repository! make desired changes to locals-*.tf and...
  ```sh
  terraform init
  terraform apply
  ```

  At this point you will most likely run into an error;

  ```text
  aws_organizations_organization.this: Creating...
  ╷
  │ Error: Error creating organization: AlreadyInOrganizationException: The AWS account is already a member of an organization.
  │
  │   with aws_organizations_organization.this,
  │   on main.tf line 20, in resource "aws_organizations_organization" "this":
  │   20: resource "aws_organizations_organization" "this" {
  │
  ╵
  ```

  This is expected since we already created an aws-organization. To fix it we need get the organization id and import it to terraform.

  ```sh
  # YOUR_ID
  aws organizations describe-organization | jq -r ".Organization.Id"
  
  terraform import aws_organizations_organization.this YOUR_ID
  ```

  After a successful import you can run `terraform apply` again.

* After creating accounts, 
  * be sure to add the [project-state](../tfstate/README.md#project-state) buckets.
  * apply the account baseline to each account -- TBD
  * use an appropriate user and configure profiles -- TBD



## TODO:

* enable trusted access https://docs.aws.amazon.com/accounts/latest/reference/using-orgs-trusted-access.html
* enable RAM sharing https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html#getting-started-sharing-orgs?icmpid=docs_orgs_console
* enable tag policies https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html
* enable VPC reachability analyzer https://us-east-1.console.aws.amazon.com/organizations/v2/home/services/VPC%20Reachability%20Analyzer



