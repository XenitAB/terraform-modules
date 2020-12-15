resource "aws_kms_key" "velero" {
  description             = "Velero S3 Bucket Encrytion for ${var.environment}-${data.aws_region.current.name}-${var.name}-velero"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = "${var.environment}-${var.name}-velero"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "velero" { #tfsec:ignore:AWS002
  bucket = "${var.environment}-${data.aws_region.current.name}-${var.name}-velero"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.velero.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = "${var.environment}-${data.aws_region.current.name}-${var.name}-velero"
    Environment = var.environment
  }
}
