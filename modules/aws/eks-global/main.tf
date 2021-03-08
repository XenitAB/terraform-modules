terraform {
  required_version = "0.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.31.0"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
