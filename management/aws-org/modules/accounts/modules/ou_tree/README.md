# ou_tree

given a list of companies (var.level_0), constructs the tier (var.level_1) based organizational unit (var.level_2) structure. e.g. 


```txt
root
├── acme
│   ├── notprod
│   │   ├── infrastructure
│   │   ├── security
│   │   └── workloads
│   └── prod
│       ├── infrastructure
│       ├── security
│       └── workloads
└── iceburg
    ├── notprod
    │   ├── infrastructure
    │   ├── security
    │   └── workloads
    └── prod
        ├── infrastructure
        ├── security
        └── workloads
```


## Outputs

The module outputs a `map` of the OU structure. E.g.

```terraform
outputs = {
  "map" = {
    "." = {
      "id" = "r-zqhp"
      "path" = "r-zqhp"
    }
    "iceburg" = {
      "id" = "ou-zqhp-k0hp1bsy"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy"
    }
    "iceburg.notprod" = {
      "id" = "ou-zqhp-t2p3wucn"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy/ou-zqhp-t2p3wucn"
    }
    "iceburg.notprod.infrastructure" = {
      "id" = "ou-zqhp-rx4bapym"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy/ou-zqhp-t2p3wucn/ou-zqhp-rx4bapym"
    }
    "iceburg.notprod.security" = {
      "id" = "ou-zqhp-sjmpbxgd"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy/ou-zqhp-t2p3wucn/ou-zqhp-sjmpbxgd"
    }
    "iceburg.notprod.workloads" = {
      "id" = "ou-zqhp-467mbkit"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy/ou-zqhp-t2p3wucn/ou-zqhp-467mbkit"
    }
    "iceburg.prod" = {
      "id" = "ou-zqhp-w7uqcs1a"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy/ou-zqhp-w7uqcs1a"
    }
    "iceburg.prod.infrastructure" = {
      "id" = "ou-zqhp-q0a0ddtq"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy/ou-zqhp-w7uqcs1a/ou-zqhp-q0a0ddtq"
    }
    "iceburg.prod.security" = {
      "id" = "ou-zqhp-8eqasmqb"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy/ou-zqhp-w7uqcs1a/ou-zqhp-8eqasmqb"
    }
    "iceburg.prod.workloads" = {
      "id" = "ou-zqhp-9tu9momt"
      "path" = "r-zqhp/ou-zqhp-k0hp1bsy/ou-zqhp-w7uqcs1a/ou-zqhp-9tu9momt"
    }
  }
}
```