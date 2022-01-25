/**
  * # Core
  *
  * This module is used to configure an opinionated VPC for XKS.
  *
  */

terraform {
  required_version = "0.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  global_tags = {
    Name        = var.name
    Environment = var.environment
    Module      = "core"
  }
}
