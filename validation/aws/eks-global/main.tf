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

module "eks-global" {
  source = "../../../modules/aws/eks-global"

  environment       = "dev"
  name              = "eks"
}
