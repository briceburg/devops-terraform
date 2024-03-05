# TODO: revisit when https://github.com/hashicorp/terraform/issues/24476 resolves, or terraform 'stacks' is available.

provider "aws" {
  alias = "notprod"

  profile = "notprod-shared-services/operate" # TODO: this should be security-tooling, however we have limited accounts in free tier.
  region  = "us-east-2"

  default_tags {
    tags = module.config.tags
  }
}

provider "aws" {
  alias = "notprod-network"

  profile = "notprod-network/operate"
  region  = "us-east-2"

  default_tags {
    tags = module.config.tags
  }
}

provider "aws" {
  alias = "notprod-sandbox"

  profile = "notprod-sandbox/operate"
  region  = "us-east-2"

  default_tags {
    tags = module.config.tags
  }
}

provider "aws" {
  alias = "prod"

  profile = "prod-shared-services/operate" # TODO: this should be security-tooling, however we have limited accounts in free tier.
  region  = "us-east-2"

  default_tags {
    tags = module.config.tags
  }
}


