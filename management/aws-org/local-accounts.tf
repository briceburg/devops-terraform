locals {
  account_map = {
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
}
