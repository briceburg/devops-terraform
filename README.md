# devops-terraform

## DevOps Challenges

### Cloud Presence 

* Organizational bootstrapping.
  * initial setup of tfstate buckets and accounts/access patterns. DIY versus Terraform Enterprise / Spacelift
* Account Foundations
  * RBAC. How to safely empower build-run teams as an org grows.
  * Progressive workflow requirements (`sandbox` [free for all] -> `production` [formal processes])
  * Costs, e.g. weekly nuke of sandbox resources, per-tier resource sizing/retention/configuration
  * Flexible, intuitive permissions and account structure
* Network Foundations and Reference Platforms
  * Building blocks for consistently using the provider
* Strategies for automation in CI/CD Pipelines
  * OIDC roles

#### Order of Operations

To get started in AWS, first read over [management/aws/README.md](./management/aws/README.md). It contains an [initial setup guide](./management/aws/README.md#initial-setup-bootstrapping) detailing the steps below.

1. Create a [Org Management account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/management-account.html) and enable [IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/organization-instances-identity-center.html). Name the account `aws-org-management`.
1. Terraform the management state bucket.
1. Terraform organization accounts, users, and permissions.
1. Terraform project state buckets.

---

1. Terraform networks.
1. Terraform DNS.
1. Terraform namespaces.

Enjoy a namespace-aware module ecosystem. 


## Development Guidelines

* When it makes sense, breakout subdirectories into their own repository. This will have maintainership and CI benefits. 
  * Use [git subtree](https://www.atlassian.com/git/tutorials/git-subtree) to preserve history.
* [Google's Terraform Best Practices](https://cloud.google.com/docs/terraform/best-practices-for-terraform)

### Named Profiles

Currently named profiles are used to access particular accounts. Copy the contents from [tools/aws/config](./tools/aws/config) into your `~/.aws/config` file and be sure to keep it up to date.

TODO: revisit tooling

## TODO
* rename `namespaces` to `deploy-zones`
* rename `notprod` tier to `sandbox`?

