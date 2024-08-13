
variable "grafana_otelcol_exporter_endpoint" {
  description = "Endpoint for the otel exporter that is deployed within the grafana-alloy deployment."
  type        = string
}

variable "grafana_otelcol_auth_basic_username" {
  description = "Username for the grafana-alloy otel authentication, the password is set via an env variable."
  type        = string
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    azure_key_vault_name = string
    keyvault_secret_name = string
  })
  default = {
    azure_key_vault_name = ""
    keyvault_secret_name = ""
  }
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}
