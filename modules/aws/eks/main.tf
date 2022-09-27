terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
      # Need both providers, one is default and the other is
      # to create the eks cluster and get auth token
      configuration_aliases = [aws.eks_admin]
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
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
