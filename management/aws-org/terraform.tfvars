#
# org settings
#

account_email = {
  domain = "iceburg.net"
  user   = "devops"
}
management_account_id = 891377375061
organization          = "iceburg-devops"
sso_region            = "us-east-2"
sso_start_url         = "https://d-9a67708f86.awsapps.com/start"
vcs_url               = "https://github.com/briceburg/devops-terraform.git"

#
# org entities
#

accounts = {
  notprod = {
    infrastructure = [
      "network",
      "shared-services"
    ]
    security = [
      "logs",
      # commenting out to remain within free tier account number limitations
      #"security-tooling"
    ]
    workloads = [
      "sandbox"
    ]
  }
  prod = {
    infrastructure = [
      "network",
      "shared-services"
    ]
    security = [
      "logs",
      # commenting out to remain within free tier account number limitations
      #"security-tooling"
    ]
    workloads = [
      "sandbox"
    ]
  }
}

groups = {
  admin    = "administrative group"
  audit    = "audit group"
  engineer = "engineering group"
  prodeng  = "production engineering"
  support  = "support group"
}

permission_sets = {
  admin   = "Read/Write Access to all resources."
  operate = "Operate Access to terraformed resources."
  read    = "Read Access to terraformed resources."
}

permissions_by_ou = {
  # '.' matches all accounts
  "." = [
    {
      groups          = ["admin"]
      permission_sets = ["admin", "operate", "read"]
    },
    {
      groups          = ["prodeng"]
      permission_sets = ["operate", "read"]
    },
    {
      groups          = ["audit"]
      permission_sets = ["read"]
    },
  ]

  "notprod.infrastructure" = [
    {
      groups          = ["engineer", "support"]
      permission_sets = ["read"]
    },
  ]

  "notprod.workloads" = [
    {
      groups          = ["engineer", "support"]
      permission_sets = ["operate", "read"]
    },
  ]

  "prod.workloads" = [
    {
      groups          = ["engineer", "support"]
      permission_sets = ["read"]
    },
  ]
}

permissions_by_account = {
  "notprod-shared-services" = [
    {
      groups          = ["support"]
      permission_sets = ["operate"]
    },
  ]
}

permissions_by_group = {
  "engineer" = [
    {
      accounts        = ["notprod-shared-services"]
      permission_sets = ["operate"]
    },
  ]
}

users = {
  "admin@org.com" = {
    name   = "Org Admin"
    groups = ["admin"]
  }
  "robin.smith@org.com" = {
    name   = "Robin Smith"
    groups = ["prodeng"]
  }
  "moss.andrews@org.com" = {
    name   = "Moss Andrews-Sanchez"
    groups = ["engineer"]
  }
  "support@org.com" = {
    name   = "Support User"
    groups = ["support", "audit"]
  }
}
