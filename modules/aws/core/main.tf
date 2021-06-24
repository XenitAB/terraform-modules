/**
  * # Core
  *
  * This module is used to configure a standard public/private VPC and accompanying Route53 zome.
  *
  */


terraform {
  required_version = "0.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.48.0"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
