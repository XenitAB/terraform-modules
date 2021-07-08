terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "eks-global" {
  source = "../../../modules/aws/eks-global"

  environment   = "dev"
  name          = "eks"
  unique_suffix = 1337
}
