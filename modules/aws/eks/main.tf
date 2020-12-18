/**
  * # Core
  *
  * More details to be added.
  * 
  * ![Terraform Graph](files/graph.svg "Terraform Graph")
  *
  */
  
terraform {
  required_version = "0.13.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.20.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

