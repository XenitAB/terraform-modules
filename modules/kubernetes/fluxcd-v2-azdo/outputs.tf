output "output_depends_on" {
  description = "Output dependency for module"
  sensitive   = true
  value       = [kubectl_manifest.sync, kubernetes_secret.main]
}
