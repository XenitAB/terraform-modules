variable "cloud_provider" {
  description = "Name of cloud provider"
  type        = string
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    azure_key_vault_name = string
    identity = object({
      client_id   = string
      resource_id = string
      tenant_id   = string
    })
  })
  default = {
    azure_key_vault_name = ""
    identity = {
      client_id   = ""
      resource_id = ""
      tenant_id   = ""
    }
  }
}

variable "aws_config" {
  description = "AWS specific configuration"
  type = object({
    role_arn = string
  })
  default = {
    role_arn = ""
  }
}

variable "cluster_name" {
  description = "Name of the prometheus cluster"
  type        = string
}

variable "environment" {
  description = "The environment in which the prometheus instance is deployed"
  type        = string
}

variable "tenant_id" {
  description = "The tenant id label to apply to all metrics in remote write"
  type        = string
  default     = ""
}

variable "remote_write_authenticated" {
  description = "Adds TLS authentication to remote write configuration if true"
  type        = bool
  default     = true
}

variable "remote_write_url" {
  description = "The URL where to send prometheus remote_write data"
  type        = string
}

variable "volume_claim_storage_class_name" {
  description = "StorageClass name that your pvc will use"
  type        = string
  default     = "default"
}

variable "volume_claim_size" {
  description = "Size of prometheus disk"
  type        = string
  default     = "5Gi"
}

variable "resource_selector" {
  description = "Monitoring type labels to look for in Prometheus resources"
  type        = list(string)
  default     = ["platform"]
}

variable "namespace_selector" {
  description = "Kind labels to look for in namespaces"
  type        = list(string)
  default     = ["platform"]
}

# Opt in to additional monitors

variable "falco_enabled" {
  description = "Should Falco be enabled"
  type        = bool
  default     = false
}

variable "opa_gatekeeper_enabled" {
  description = "Should OPA Gatekeeper be enabled"
  type        = bool
  default     = false
}

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}

variable "flux_enabled" {
  description = "Should flux-system be enabled"
  type        = bool
  default     = false
}

variable "csi_secrets_store_provider_azure_enabled" {
  description = "Should csi-secrets-store-provider-azure be enabled"
  type        = bool
  default     = false
}

variable "csi_secrets_store_provider_aws_enabled" {
  description = "Should csi-secrets-store-provider-aws be enabled"
  type        = bool
  default     = false
}

variable "aad_pod_identity_enabled" {
  description = "Should aad pod dentity be enabled"
  type        = bool
  default     = false
}

variable "azad_kube_proxy_enabled" {
  description = "Should azad-kube-proxy be enabled"
  type        = bool
  default     = false
}

# This should be removed, https://github.com/kubernetes/kube-state-metrics/issues/1631
variable "kube_state_metrics_namepsaces" {
  description = "Comma-separated list of namespaces to be enabled. To get metrics from all namespaces use ''"
  type        = string
}
