resource "aws_s3_bucket" "s3BucketVelero" {
  bucket = "s3-${var.environment}-${var.locationShort}-${var.commonName}-velero"
  acl    = "private"

  tags = {
    Name = "s3-${var.environment}-${var.locationShort}-${var.commonName}-velero"
  }
}

resource "aws_s3_bucket" "s3BucketHelm" {
  bucket = "s3-${var.environment}-${var.locationShort}-${var.commonName}-helm"
  acl    = "private"

  tags = {
    Name = "s3-${var.environment}-${var.locationShort}-${var.commonName}-helm"
  }
}
