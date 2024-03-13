# tfstate

manage resources for housing [remote terraform state](https://developer.hashicorp.com/terraform/language/state).

## usage

modify the [config module variables](./modules/config/variables.tf) to provide _default values_ appropriate to your organization.

### management state

the `management` state bucket retains state for resources within the management account, including the state of the other state buckets. it lives in the [Org Management account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html).

:zap: The `management` tfstate bucket MUST be created before running any other terraforms. As such, its own state is kept locally and checked into this repository. **when running an apply, be sure to check in the updated state to this repository**

```sh
# git checkout this repository.

# 1. enter the tfstate 'management' environment
cd management/tfstate/environments/management

# 2. execute terraform per usual. no workspaces!
terraform init
terraform apply

# see output for state bucket name.

# 3. be sure to commit changes to state after applying the management bucket, e.g.
git add terraform.tfstate && \
  git commit -m "updated management tfstate" 
```

#### using the management state bucket

when terraform manages resources in the _management_ account, the management tfstate bucket should be used. typically this is configured in a `backend.tf` file, e.g. the [project-state backend.tf](./environments/project-state/backend.tf).

```terraform
terraform {
  backend "s3" {
    bucket         = "<management-bucket-name>"
    dynamodb_table = "<management-bucket-name>-locks"
    encrypt        = true
    key            = "<directory>/<project-name>/<environment>/terraform.tfstate"
    profile        = "<management-account-name>/<role>"
    region         = "<state_region>"
  }
}
```
e.g.

```terraform
terraform {
  backend "s3" {
    bucket         = "iceburg-tfstate-management"
    dynamodb_table = "iceburg-tfstate-management-locks"
    encrypt        = true
    key            = "management/aws/accounts/terraform.tfstate"
    profile        = "aws-org-management/operate"
    region         = "us-east-2"
  }
}
```

### project state

project state buckets exist in the [shared-services account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/shared-services.html) of each tier, which keeps production state separate from non-production.

:zap: before terraforming project buckets, ensure that the shared-services accounts exist and [profiles have been configured](TODO). use the [aws accounts](../aws/environments/accounts/) terraform for creating accounts.

 **afterwards, ensure [backend.tf](./environments/project-state/backend.tf) is correctly configured to use the management state bucket.**
 
 **reflect changes to tiers under [main.tf](./environments/project-state/main.tf) and set appropriate account IDs in [config module variables](./modules/config/variables.tf).**

```sh
# enter the tfstate 'project-state' environment
cd environments/project-state

# execute terraform per usual. no workspaces!
terraform init
terraform apply
```

#### using project state buckets

example backend configuration for terraform configurations. refer to [AWS S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) for all configuration parameters.

```terraform
terraform {
  backend "s3" {
    bucket         = "<state-bucket-name>-<tier>"
    dynamodb_table = "<state-bucket-name>-<tier>-locks"
    encrypt        = true
    key            = "<directory>/<project-name>/<environment>/terraform.tfstate"
    profile        = "<tier>-shared-services/<role>"
    region         = "<state_region>"
  }
}
```

> :bulb: the `<tier>-shared-services/operate` refers to a [named profile](../../README.md#named-profiles) that assumes the "operate" role (permission set) in the shared-services account created via the [accounts](../aws/environments/accounts/) management terraform. 

e.g.

```terraform
terraform {
  backend "s3" {
    bucket         = "iceburg-tfstate-prod"
    dynamodb_table = "iceburg-tfstate-prod-locks"
    encrypt        = true
    key            = "workloads/foo/us-1/terraform.tfstate"
    profile        = "prod-shared-services/operate"
    region         = "us-east-2"
  }
}
```

## TODO
* use org-data discovery for defining shared-services account IDs?
* do not rely on Tier tag in aws-tfstate-bucket.

