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



## Development Guidelines

* When it makes sense, breakout subdirectories into their own repository. This will have maintainership and CI benefits. 
  * Use [git subtree](https://www.atlassian.com/git/tutorials/git-subtree) to preserve history.
* [Google's Terraform Best Practices](https://cloud.google.com/docs/terraform/best-practices-for-terraform)

### Named Profiles

Currently named profiles are used to access particular accounts. Copy the contents from [tools/aws/config](./tools/aws/config) into your `~/.aws/config` file and be sure to keep it up to date.

TODO: revisit tooling

