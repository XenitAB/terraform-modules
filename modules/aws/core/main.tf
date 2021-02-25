terraform {
  required_version = "0.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.29.1"
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
