# aws-prefix-lists

Create AWS Managed Prefix Lists

## Usage

```terraform
module "prefix_lists" {
  source = "modules//aws-prefix-lists"

  managed_list_map = {
    developers = {
      erika  = ["1.2.3.4/32", "2600:1700:500:8740::/64"]
      darlan = ["5.6.7.8/32"]
    }
    vendors = {
      # https://www.metabase.com/cloud/docs/ip-addresses-to-whitelist.html
      metabase = ["18.207.81.126/32", "3.211.20.157/32", "50.17.234.169/32"]
    }
    vpns = {
      azure-west = ["1.2.3.4/32"]
    }
  }
}
```