output "output_depends_on" {
  description = "Output dependency for module"
  sensitive   = true
  value       = helm_release.cert_manager
}