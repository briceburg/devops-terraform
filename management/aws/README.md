# aws-management

Manage an AWS Organization including;

* accounts
* users
* permissions

> :cake: skips [AFT](https://docs.aws.amazon.com/controltower/latest/userguide/taf-account-provisioning.html) / Control Tower in favor of pure Terraform approach.

Assumes [IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/organization-instances-identity-center.html) has been enabled in the [Org Management account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html).


## Accounts

Each account belongs to a **tier** (aka a parent OU), such as `prod`. A [SCP](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html) is in place that denies access from resources in one tier from accessing resources from another. This enhances security.

For instance, if there is a policy on a bucket living in an account under the `prod` tier that _explicitly_ allows reading from an IAM/ECS role that exists under the `notprod` tier, reads from that role will be _denied_ even through the policy gives them permission. Modifying the SCP to explicitly allow this behavior is needed as well.

For demonstration purposes, two tiers are created -- `prod` and `notprod` in the "iceburg-devops" organization following the the [AWS Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/architecture.html); 

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

> :bulb: Account names are prefixed with the tier they belong to, e.g. `notprod-sandbox` and `prod-logs`.


## Usage

Terraform must have the ability to manage resources in the [Org Management account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html). 

:zap: We assume the management account is named `aws-org-management`, and an AWS CLI profile named `aws-org-management/operate` is configured to access it.


### Initial Setup (bootstrapping)

Currently, [named AWS profiles](../../README.md#named-profiles) are used to manage resources in target accounts and terraform access state. When first starting out, an administrative user with appropriate profiles must be created. **This user and permission set will only be used for interacting with the management account to create the initial tfstate bucket and accounts**. Recommended procedure; 

#### AWS Console

* Enable IAM Identity Center
  * [Step 1](./docs/img/01-IAM-Identity-Center-Enablement-1.png), [Step 2](./docs/img/01-IAM-Identity-Center-Enablement-2.png), [Step 3](./docs/img/01-IAM-Identity-Center-Enablement-3.png)
* Create `breakglass` _User_
  * [Step 1](./docs/img/02-Create-User.png)
* Create `AdministratorAccess` Permission Set
  * [Step 1](./docs/img/03-Create-Permission-Set-1.png), [Step 2](./docs/img/03-Create-Permission-Set-2.png)
* Assign Admin Permission Set + `breakglass` User to the Management Account
  * [Step 1](./docs/img/04-Assign-Permissions-1.png), [Step 2](./docs/img/04-Assign-Permissions-2.png), [Step 3](./docs/img/04-Assign-Permissions-3.png).
* Ensure you can login as `breakglass` user and set password. It's good to have MFA but can be disabled via IAM Identity Center `Settings` if necessary.
  

#### Local Terminal

Next, From your terminal that has [aws cli](https://aws.amazon.com/cli/) installed;

* Start an SSO session as this user and configure the `aws-org-management/operate` profile;
  ```sh
  # 1. configure a new session
  aws configure sso-session

  # name the session <org>, e.g. 'iceburg'
  # enter the correct start_url and region (found in IAM Identity Center "Dashboard")
  # accept default scopes

  # 2. login to the session
  aws sso login --sso-session <org>

  # NOTE: you will re-use the login command to refresh a session/login after it expires.

  # 3. configure the  profile (instructions below)
  aws configure sso

  # select the session name, e.g. 'iceburg' 
  # select management account and AdministratorAccess role (permission set)
  # accept defaults for region + format
  # name the profile `aws-org-management/operate`
  # IMPORTANT: you can always edit ~/.aws/config to make changes
  ```

#### Management State

* Create the management tfstate bucket, following [management-state](../tfstate/README.md#management-state) instructions.


#### Organization Accounts

* Configure the [accounts](./environments/accounts/README.md) terraform to suit your organization.
  * ensure the [config module variables](./modules/config/variables.tf) has correct default values.
  ```sh
  cd environments/accounts

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
  AWS_PROFILE=aws-org-management/operate \
    aws organizations describe-organization | jq -r ".Organization.Id"
  
  terraform import aws_organizations_organization.main YOUR_ID
  ```

  After a successful import you can run `terraform apply` again.

#### Organization Users and Permissions

* Continue configuring and applying the the [users-and-groups](./environments/users-and-groups/) and [permissions](./environments/permissions/) terraforms.

#### Final Steps

:tada: You now have terraform managed AWS Presence! A few last bits...

* appropriately configure [named AWS profiles](../../README.md#named-profiles).
* add the [project tfstate](../tfstate/README.md#project-state) buckets.
* apply the account baseline to each account -- TODO
* setup networks and deployment zones -- TODO
  
Enjoy the a module ecosystem working together and please contribute back.

## TODO:

* enable trusted access https://docs.aws.amazon.com/accounts/latest/reference/using-orgs-trusted-access.html
* enable tag policies https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html
* enable VPC reachability analyzer https://us-east-1.console.aws.amazon.com/organizations/v2/home/services/VPC%20Reachability%20Analyzer
* introduce cross-tier-denial SCP




