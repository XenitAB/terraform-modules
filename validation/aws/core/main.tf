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
        tags = {
          "kubernetes.io/role/elb" = "1"
        }
      },
    ]
    private_subnets = [
      {
        name_prefix             = "eks1-nodes"
        cidr_block              = "10.0.1.0/22"
        availability_zone_index = 0
        public_routing_enabled  = true
        tags = {
          "kubernetes.io/role/internal-elb" = "1"
          "kubernetes.io/cluster/eks1-dev"  = "shared"
        }
      },
    ]
  }
  vpc_peering_config_requester = [
    {
      name                   = "tenant1-dev"
      peer_owner_id          = "account-id"
      peer_vpc_id            = "vpc-1234"
      destination_cidr_block = "10.0.0.0/24"
    },
  ]
  dns_zone         = "foobar.com"
  dns_zone_enabled = true
}
