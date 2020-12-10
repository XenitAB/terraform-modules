output "output_depends_on" {
  description = "Output dependency for module"
  sensitive   = true
  value       = [kubernetes_secret.cluster, kubectl_manifest.sync]
}
