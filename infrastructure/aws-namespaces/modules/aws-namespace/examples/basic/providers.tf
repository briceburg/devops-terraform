provider "aws" {
  profile = "notprod-sandbox/operate"
  region  = "us-east-1"

}

provider "aws" {
  alias = "network"

  profile = "notprod-network/operate"
  region  = "us-east-2"
}

