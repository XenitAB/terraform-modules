terraform {
  required_version = "0.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
    azuread = {
      version = "2.19.1"
      source  = "hashicorp/azuread"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  global_tags = {
    Name        = var.name
    Environment = var.environment
    Module      = "eks-global"
  }
}
