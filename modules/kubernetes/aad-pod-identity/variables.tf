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

variable "tolerate_all_taints" {
  description = "If true the nmi daemonset will schedule on all nodes no matter the taints on the nodes."
  type        = bool
  default     = false
}
