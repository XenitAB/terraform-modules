/**
  * # EKS Core
  *
  * This module is used to configure EKS clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.34.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.25.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

data "aws_region" "current" {}
