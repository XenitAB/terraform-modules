terraform {
  required_version = "0.13.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.20.0"
    }
  }
}

resource "aws_s3_bucket" "velero" {
  bucket = "${var.environment}-${var.region.location}-${var.name}-velero"
  acl    = "private"

  tags = {
    Name = "${var.environment}-${var.region.location}-${var.name}-velero"
    Environment = var.environment
  }
}
