# devops-terraform

## DevOps Challenges

* Terraform bootstrapping.
  * initial setup of tfstate buckets and accounts/access patterns. DIY versus Terraform Enterprise / Spacelift
* Cloud Presence; account foundations
* Cloud RBAC. How to safely empower build-run teams as an org grows.
  * Progressive workflow requirements (`sandbox` [free for all] -> `production` [formal processes])
  * Costs, e.g. weekly nuke of sandbox resources, per-tier resource sizing/retention/configuration
  * Flexible, intuitive permissions and account structure


## development guidelines

* When it makes sense, breakout subdirectories into their own repository. This will have maintainership and CI benefits. Use [git subtree](https://www.atlassian.com/git/tutorials/git-subtree) to preserve history.
* [Google's Terraform Best Practices](https://cloud.google.com/docs/terraform/best-practices-for-terraform)
* [AWS Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/architecture.html)

