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

module "eks" {
  source = "../../../modules/aws/eks"

  environment       = "dev"
  region = {
    location       = "eu-west-1"
    location_short = "eu-west-1"
  }
  name              = "eks"
  core_name = "core"
  eks_config = {
    kubernetes_version = "1.18"
    cidr_block = "10.0.16.0/20"
    node_groups = []
  }
  velero_s3_bucket_arn = "arn"
}
