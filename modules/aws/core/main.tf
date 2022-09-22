/**
  * # Core
  *
  * This module is used to configure a standard public/private VPC and accompanying Route53 zone.
  *
  */

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
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
