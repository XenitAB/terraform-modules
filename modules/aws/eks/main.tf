terraform {
  required_version = "0.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
      # Need both providers, one is default and the other is
      # to create the eks cluster and get auth token
      configuration_aliases = [aws.eks_admin]
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  global_tags = {
    Name        = var.name
    Environment = var.environment
    Module      = "eks"
  }
}
