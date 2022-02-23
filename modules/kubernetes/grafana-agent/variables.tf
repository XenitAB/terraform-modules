variable "remote_write_urls" {
  description = "the remote write urls"
  type = object({
    metrics = string
    logs    = string
    traces  = string
  })
  default = {
    metrics = ""
    logs    = ""
    traces  = ""
  }
}

variable "credentials" {
  description = "grafana-agent credentials"
  type = object({
    metrics_username = string
    metrics_password = string
    logs_username    = string
    logs_password    = string
    traces_username  = string
    traces_password  = string
  })
  sensitive = true
}

variable "cluster_name" {
  description = "the cluster name"
  type        = string
}

variable "environment" {
  description = "the name of the environment"
  type        = string
}

variable "vpa_enabled" {
  description = "Should vpa be enabled"
  type        = bool
  default     = false
}

variable "tenant_namespaces" {
  description = "A list of the tenant namespaces used by kube-state-metrics"
  type        = list(string)

  validation {
    condition     = length(var.tenant_namespaces) > 0
    error_message = "The tenant_namespaces needs to at least contain one namespace in the list."
  }
}
