resource "aws_kms_key" "velero" {
  description             = "Velero S3 Bucket Encrytion for ${data.aws_region.current.name}-${var.name}-velero"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = var.name
    Environment = var.environment
    Component   = "velero"
  }
}

resource "aws_s3_bucket" "velero" {
  bucket = "${data.aws_region.current.name}-${var.name}-${var.environment}-${var.unique_suffix}-velero"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.velero.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = var.name
    Environment = var.environment
    Component   = "velero"
  }
}
