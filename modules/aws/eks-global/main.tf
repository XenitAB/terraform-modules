terraform {
  required_version = "0.13.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.29.1"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
