output "output_depends_on" {
  description = "Output dependency for module"
  sensitive   = true
  value       = [helm_release.external_dns, helm_release.external_dns_extras]
}
