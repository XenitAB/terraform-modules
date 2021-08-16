terraform {
  required_version = "0.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.54.0"
    }
    azuread = {
      version = "1.6.0"
      source  = "hashicorp/azuread"
    }
  }
}

data "aws_caller_identity" "current" {}
