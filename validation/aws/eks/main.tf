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
  name              = "eks"
  core_name = "core"
  eks_config = {
    kubernetes_version = "1.18"
    cidr_block = "10.0.16.0/20"
    node_groups = []
  }
  velero_config = {
    s3_bucket_arn = "foo"
    s3_bucket_id = "bar"
  }
}
