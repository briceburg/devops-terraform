# aws-namespace

A Namespace is a _reference platform_ which brings convention to shared cloud infrastructure; in AWS this includes how VPC subnets, Security Groups, ECS, KMS, Route53, Lambdas, &c are provisioned and utilized. 

Namespaces provide the basic discovery, network, logging, and security bits to the resources, services, and functions within.

A "Namespace-aware" module ecosystem targets namespaces, for instance a module for deploying containers to a namespaces is named aws-namespace-ecs-deploy, which takes care to register services with load balancers, aggregate logs within cloudwatch, communicate internally with other services, &c, ultimately making it much easier to get started and iterate convention. 


## usage

```terraform
module "namespace" {
  source    = "//aws-namespace"
  
  id             = "jabba-west"
  load_balancers = []
  stage          = "DEVELOPMENT"

  providers = {
    aws     = aws
    aws.dns = aws.network # DNS account where the apex zone lives
    aws.ram = aws.network # RAM share account (prefix lists, VPCs, transit gateways, &c)
  }
}
```

### Identifier

The namespace identifier ("id") must be unique and is used as a naming prefix for resources within the namespace. For instance, the namespace's ECR will be named `<namespace.id>-images`. Some example namespace names are; `sassafras`, `dev-1`, and `eucalyptus-prod`. 

:zap: pass the namespace identifier as a variable named `namespace_id` (string) to differentiate it from the `namespace` variable containing the [Namespace Object](#namespace-object).


### Stage

A stage can be passed as input. Valid values are "PRODUCTION" and "DEVELOPMENT". The stage effects behaviors, such as how many days logs are retained, if final snapshots of RDS instances are performed, and the sharing of resources.

### DNS

To provision namespaces, a Route53 apex zone must be created. We recommend creating this zone in the network account and naming it according to tier, e.g. `notprod.namespaces.iceburg.net`. This will clearly separate production namespaces from non-production at the DNS level. See infrastructure/aws-dns for example terraform configuration.

Each namespace gets a Route53 zone that attaches to the apex zone through DNS delegation. For instance, for a namespace named `foo`, its zone would be `foo.notprod.namespaces.iceburg.net` and NS records for `foo` pointing to the namespace zone's nameservers are added to the `notprod.namespaces.iceburg.net` apex zone. 

To support the common case where the apex zone is in a different account than the namespace being provisioned, the module requires the "aws.dns" provider configuration alias referencing the account holding the Route53 apex zone.


## Conventions

### Namespace Object

Module output is considered the "Namespace Object" and passed to namespace-aware modules so that they may leverage namespace resources and make configuration decisions (such as the number of days to retain logs based on namespace stage). E.g.

```terraform
module "namespace" {
  source  = "//aws-namespace"
  ...
}

module "deployment" {
  source    = "//aws-namespace-ecs-deployment
  namespace = module.namespace
  ...
}
```

### Namespace Discovery 

If the namespace object is not available in the current terraform configuration, it can be "discovered" with the [discovery module](../aws-discovery/) and passed as input in the same manner, e.g.

```terraform
module "discovery" {
  source  = "//aws-discovery"
  lookups = ["namespaces/jabba-west"]
}

module "deployment" {
  source    = "//aws-ecs-deployment"
  namespace = module.discovery.results["namespaces/jabba-west"]
  ...
}
```

#### Secuirty Groups 

Three classes of security groups are provided with basic sets of rules. Additional rules can be attached downstream using the sg-rule-attachments module.

name | description | example rules
--- | --- | ---
default | Default group that allows traffic between services within the namespace and enables outbound. Assign to all resources. | self
public | Allow ingress from public WAN sources. | 0.0.0.0/0, developer IPs prefix list
trusted | Allow ingress from trusted WAN/Edge sources. | VPN IPs, [CloudFront prefix list](https://aws.amazon.com/about-aws/whats-new/2022/02/amazon-cloudfront-managed-prefix-list/)

#### Network Subnets

Three tiers of subnets spread across 3† availability zones are available to the namespace network.  When managing resources downtream of this module you must choose the appropriate subnets to associate with.


name | targets | description
--- | --- | ---
public | ALBs, NLBs | For services needing a public IP.
private | EC2, ECS, Lambda | For most services/functions requiring [egress](#egress).
intra | RDS, Elasticache | For air-gapped services.

:bulb: Services within the namespace can communicate with eachother regardless of their subnet.

> † subnets in 3 availability zones allows clustered services to reach quorum within a region.

##### egress

”Egress” refers to traffic directed outside the VPC/Network CIDR. This **includes traffic to other AWS services**. E.g. `curl https://metrics.datadoghq.com/` and `aws ecr get-login-password` require the performer have egress to succeed.

Both the `public` and `private` subnets provide egress -- public resources through their associated public IP and the private resources through a transit gateway typically in the network account.

:zap: Services that use the AWS SDK require egress (e.g. to communicate with SecretsManager). The `intra` subnet is configured for access to S3 and DynamoDB. If access to other services is required an [interface endpoint](https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/what-are-vpc-endpoints.html) must be configured.  

##### Load Balancers

TBD: public, trusted, nlb.

#### log groups

TBD: ecs tasks, lambdas 

