# terraform-aws-namespace-lb

provides load balancers and endpoints for services within a namespace to associate with.

* public (ALB)
* trusted (ALB)
* nlb (NLB)

### TODO

* support placing NLB in front of ALB(s)
  * ALBs would move to secure/private subnet from unsecure/public in this situation.
  * <https://aws.amazon.com/blogs/networking-and-content-delivery/application-load-balancer-type-target-group-for-network-load-balancer/>
