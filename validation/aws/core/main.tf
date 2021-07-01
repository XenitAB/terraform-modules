terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "core" {
  source = "../../../modules/aws/core"

  environment = "dev"
  name        = "core"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    public_subnets = [
      {
        cidr_block = "10.0.0.0/20"
      },
    ]
    private_subnets = [
      {
        name_prefix             = "eks1-nodes"
        cidr_block              = "10.0.1.0/22"
        availability_zone_index = 0
        public_routing_enabled  = true
      },
    ]
  }
  dns_zone = "foobar.com"
}
