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

variable "azure_metrics_enabled" {
  description = "Whether we install azure metrics monitors or not"
  type        = bool
  default     = false
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
  description = "Unique identifier of the cluster across instances."
  type        = string
}

variable "falco_enabled" {
  description = "Should Falco be enabled"
  type        = bool
  default     = false
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
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

variable "grafana_k8s_monitor_config" {
  description = "Configuration for the username and password"
  type = object({
    grafana_cloud_prometheus_host = string
    grafana_cloud_loki_host       = string
    grafana_cloud_tempo_host      = string
    azure_key_vault_name          = string
    include_namespaces            = string
    exclude_namespaces            = optional(list(string), [])
  })
  default = {
    grafana_cloud_prometheus_host = ""
    grafana_cloud_loki_host       = ""
    grafana_cloud_tempo_host      = ""
    azure_key_vault_name          = ""
    include_namespaces            = ""
    exclude_namespaces            = [""]
  }
}

variable "key_vault_id" {
  description = "Core key vault id"
  type        = string
}

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}

variable "location" {
  description = "The Azure region name."
  type        = string
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

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "spegel_enabled" {
  description = "Should Spegel be enabled"
  type        = bool
  default     = false
}

variable "subscription_id" {
  description = "The Azure subscription id"
  type        = string
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
