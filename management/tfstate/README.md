# tfstate

manage resources for housing [terraform state](https://developer.hashicorp.com/terraform/language/state).

## usage

first, modify the [config module variables](./modules/config/variables.tf) to provide _default values_ appropriate to your organization.


### management state

the `management` bucket is used to hold core infrastructure state, including the state of the other state buckets. it exists in the [Org Management account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html).

:zap: The `management` tfstate bucket MUST be created before running any other terraforms. As such, its own state is kept locally and checked into this repository. **when running an apply, be sure to check in the updated state to this repository**

```sh
# assume appropriate credentials of the management AWS account, e.g.
export AWS_PROFILE="iceburg-management/operate"

cd environments/management
terraform init
terraform apply

# be sure to commit changes to state after applying the management bucket, e.g.
git commit -am "updated management tfstate" && git push origin HEAD
```

### project state

project state buckets exist in the [shared-services account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/shared-services.html) of each tier, which keeps production state separate from non-production.

:zap: before terraforming project buckets, ensure that the shared-services accounts exist and [profiles have been configured](TBD). use the [aws-accounts](../aws-accounts) terraform for creating accounts.

 **afterwards, ensure [backend.tf](./environments/state-buckets/backend.tf) is correctly configured to use the management state bucket.**
 
 **reflect changes to tiers under [main.tf](./environments/state-buckets/main.tf)**

```sh
cd environments/state-buckets
terraform init
terraform apply
```

#### downstream project usage

example backend configuration for terraform configurations using these buckets. refer to [AWS S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) for all configuration parameters.

```terraform
terraform {
  backend "s3" {
    bucket         = "<company>-tfstate-<tier>"
    dynamodb_table = "<company>-tfstate-<tier>-locks"
    encrypt        = true
    key            = "<directory>/<project-name>/<environment>/terraform.tfstate"
    profile        = "<tier>-shared-services/<role>"
    region         = "<state_buckets_region>"
  }
}
```

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
