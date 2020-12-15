output "velero_config" {
  description = "ARN of velero s3 backup bucket"
  value = {
    s3_bucket_arn = aws_s3_bucket.velero.arn
    s3_bucket_id  = aws_s3_bucket.velero.id
  }
}
