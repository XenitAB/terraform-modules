resource "aws_kms_key" "velero" {
  description             = "Velero S3 Bucket Encrytion"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = merge(
    local.global_tags,
    {
      Name        = "Velero Encrytion"
      Application = "velero",
    },
  )
}

resource "aws_s3_bucket" "velero" { #tfsec:ignore:AWS002
  bucket = "${var.name_prefix}-${data.aws_region.current.name}-${var.environment}-${var.name}-velero-${var.unique_suffix}"
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

  tags = merge(
    local.global_tags,
    {
      Application = "velero",
    },
  )
}
