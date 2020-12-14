terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.20.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "core" {
  source = "../../../modules/aws/core"

  environment = "dev"
  name              = "core"
  vpc_config = {
    vpc_cidr_block           = "10.0.0.0/16"
    public_cidr_block = "10.0.0.0/20"
  }
  dns_zone = "foobar.com"
}
