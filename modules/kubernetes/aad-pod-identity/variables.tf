variable "prometheus_enabled" {
  description = "Should a ServiceMonitor be created"
  type        = bool
  default     = false
}

variable "aad_pod_identity" {
  description = "Configuration for aad pod identity"
  type = map(object({
    id        = string
    client_id = string
  }))
}

variable "namespaces" {
  description = "Namespaces to create AzureIdentity and AzureIdentityBindings in."
  type = list(
    object({
      name = string
    })
  )
}
