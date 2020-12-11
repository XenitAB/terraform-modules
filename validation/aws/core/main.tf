terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.20.0"
    }
  }
}

provider "aws" {}

module "core" {
  source = "../../../modules/aws/core"

  environment = "dev"
  regions = {
      location       = "West Europe"
      location_short = "we"
    }

  name              = "core"
}
