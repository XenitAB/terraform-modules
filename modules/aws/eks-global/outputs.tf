output "velero_s3_bucket_arn" {
  description = "ARN of velero s3 backup bucket"
  value       = aws_s3_bucket.velero.arn
}
