terraform {}

provider "aws" {
  region = "eu-west-1"
}

provider "azuread" {}
module "eks-global" {
  source = "../../../modules/aws/eks-global"

  environment       = "dev"
  name              = "eks"
  subscription_name = "xks"
  unique_suffix     = 1337

  namespaces = [
    {
      delegate_resource_group = true
      name                    = "team1"
    }
  ]
}
