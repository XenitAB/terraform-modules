terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "core" {
  source = "../../../modules/aws/eks-core"

  environment = "dev"
  name        = "eks-core"
  cidr_block  = "10.0.0.0/18"
  dns_zones   = ["foobar.com"]
}
