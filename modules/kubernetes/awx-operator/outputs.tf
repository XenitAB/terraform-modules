output "namespace" {
  description = "The namespace where AWX is deployed"
  value       = "awx"
}

output "instance_name" {
  description = "The name of the AWX instance"
  value       = var.awx_config.instance_name
}
