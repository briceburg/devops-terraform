# aws-network-transit-gateway

Adds a transit gateway to a [aws-network](../aws-network/).

Additional networks can route their outbound traffic through this transit gateway.


## Usage

A typical example follows;

```terraform
module "default_network" {
  source = "modules//aws-network"

  id = "default"
}

module "default_network_tgw" {
  source = "modules//aws-transit-gateway"

  network = module.default_network
}

module "devops_network" {
  source = "modules//aws-network"

  id = "devops"

  # route 'devops' network traffic through the transit gateway
  # in the 'default' network.
  transit_gateway = module.default_network_tgw
}
```

TODO: diagram