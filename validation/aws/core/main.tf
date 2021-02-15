terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "core" {
  source = "../../../modules/aws/core"

  environment = "dev"
  name              = "core"
  vpc_config = {
    cidr_block           = "10.0.0.0/16"
    public_subnet = {
      cidr_block = "10.0.0.0/20"
      tags = {}
    }
  }
  dns_zone = "foobar.com"
}
