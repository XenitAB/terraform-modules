variable "aad_pod_identity_enabled" {
  description = "Should aad pod dentity be enabled"
  type        = bool
  default     = false
}

variable "aks_name" {
  description = "The AKS cluster short name, e.g. 'aks'."
  type        = string
}

variable "azad_kube_proxy_enabled" {
  description = "Should azad-kube-proxy be enabled"
  type        = bool
  default     = false
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    azure_key_vault_name = string
  })
  default = {
    azure_key_vault_name = ""
  }
}

variable "cilium_enabled" {
  description = "If enabled, will use Azure CNI with Cilium instead of kubenet"
  type        = bool
  default     = false
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "cluster_name" {
  description = "Name of the prometheus cluster"
  type        = string
}

variable "environment" {
  description = "The environment in which the prometheus instance is deployed"
  type        = string
}

variable "falco_enabled" {
  description = "Should Falco be enabled"
  type        = bool
  default     = false
}

variable "gatekeeper_enabled" {
  description = "Should OPA Gatekeeper be enabled"
  type        = bool
  default     = false
}

variable "grafana_agent_enabled" {
  description = "Should grafana-agent be enabled"
  type        = bool
  default     = false
}

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "namespace_selector" {
  description = "Kind labels to look for in namespaces"
  type        = list(string)
  default     = ["platform"]
}

variable "node_local_dns_enabled" {
  description = "Should node local DNS be enabled"
  type        = bool
  default     = false
}

variable "node_ttl_enabled" {
  description = "Should Node TTL be enabled"
  type        = bool
  default     = false
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "promtail_enabled" {
  description = "Should promtail be enabled"
  type        = bool
  default     = false
}

variable "region" {
  description = "The region in which the prometheus instance is deployed"
  type        = string
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

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "resource_selector" {
  description = "Monitoring type labels to look for in Prometheus resources"
  type        = list(string)
  default     = ["platform"]
}

variable "spegel_enabled" {
  description = "Should Spegel be enabled"
  type        = bool
  default     = false
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "trivy_enabled" {
  description = "Should trivy be enabled"
  type        = bool
  default     = false
}

variable "volume_claim_size" {
  description = "Size of prometheus disk"
  type        = string
  default     = "10Gi"
}

variable "volume_claim_storage_class_name" {
  description = "StorageClass name that your pvc will use"
  type        = string
  default     = "default"
}

variable "vpa_enabled" {
  description = "Should vpa be enabled"
  type        = bool
  default     = false
}
