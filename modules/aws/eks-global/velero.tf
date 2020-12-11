resource "aws_s3_bucket" "velero" {
  bucket = "${var.environment}-${var.region.location}-${var.name}-velero"
  acl    = "private"

  tags = {
    Name = "${var.environment}-${var.region.location}-${var.name}-velero"
    Environment = var.environment
  }
}
