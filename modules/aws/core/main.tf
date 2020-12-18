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
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_route53_zone" "this" {
  name = var.dns_zone

  tags = {
    Name        = var.dns_zone
    Environment = var.environment
  }
}
