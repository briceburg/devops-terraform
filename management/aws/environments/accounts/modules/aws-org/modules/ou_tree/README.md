# ou_tree

given a list of companies (var.level_0), constructs the tier (var.level_1) based organizational unit (var.level_2) structure. e.g. 


```txt
root
├── acme # level_0
│   ├── notprod # level_2
│   │   ├── infrastructure # level 3
│   │   ├── security # level 3
│   │   └── workloads # level 3
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


