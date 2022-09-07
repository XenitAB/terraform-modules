terraform {
  required_version = ">= 1.2.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
    azuread = {
      version = "2.28.1"
      source  = "hashicorp/azuread"
    }
  }
}

data "aws_region" "current" {}

locals {
  global_tags = {
    Name        = var.name
    Environment = var.environment
    Module      = "eks-global"
  }
}
