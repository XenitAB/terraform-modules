terraform {
  required_version = "0.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.39.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

