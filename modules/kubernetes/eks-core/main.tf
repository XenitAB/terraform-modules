/**
  * # EKS Core
  *
  * This module is used to configure EKS clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.5.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.14.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.3.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.11.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

locals {
  # Namespace to create service accounts in
  service_accounts_namespace = "service-accounts"
}

data "aws_region" "current" {}

data "aws_route53_zone" "this" {
  name = "${var.cert_manager_config.dns_zone}."
}
