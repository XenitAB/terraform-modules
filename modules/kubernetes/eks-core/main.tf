/**
  * # EKS Core
  *
  * This module is used to configure EKS clusters.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    github = {
      source  = "hashicorp/github"
      version = "4.1.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.0.6"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.9.1"
    }
  }
}

data "aws_region" "current" {}

#locals {
#  # Namespace to create service accounts in
#  service_accounts_namespace = "service-accounts"
#}
