output "role_arn" {
  description = "ARN of the created role"
  value       = aws_iam_role.this.arn
}
