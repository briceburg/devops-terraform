output "networks" {
  value = {
    default = module.default_network
    devops  = module.devops_network
  }
}

output "ram" {
  value = module.ram
}
