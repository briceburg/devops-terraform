# accounts

the accounts terraform configures the management account to receive organizations and enables features such as RAM sharing within an organization.

additionally it manages the account structure and organizational units of an arbitrary number of "sub" organizations.

users and permissions are handled by separate terraform configurations, [users-and-groups](../users-and-groups/) and [permissions](../permissions/) accordingly. separate configurations help maintain a smaller state and facilitate targeted applies. in addition, the approach more easily supports users with access to multiple organizations. 


## Usage

* Ensure [config module variables](../../modules/config/variables.tf) default to your organization's values.
* Two "sub" organizations are exemplified in [main.tf](./main.tf), `iceburg-devops` and `acme`. customize to your needs.
* Modify [backend.tf](./backend.tf) and set to the name of your [management state bucket](../../../tfstate/README.md#management-state) created by the tfstate terraform.


```sh
cd management/aws/environments/accounts
terraform init
terraform apply
```

> :bulb: when accounts change, run the [permissions](../permissions) terraform to re-assign permission sets. TODO - depending on terraform stacks experiment, use it to trigger downstream configurations or write an alternative event based workflow.

### Discovery

A manifest of accounts and other organization details is made available through a S3 bucket named `<org>-organization-discovery`. Any entity within the organization can read from this bucket. The manifest path is `/data.json`. Example;

```
aws s3 cp s3://iceburg-devops-organization-discovery/data.json - | jq
```

This manifest is read by the [aws-discovery](https://github.com/briceburg/devops-terraform-modules/tree/main/aws-discovery) module.

> Terraform remote state outputs can also be used to discover organization details per usual.


