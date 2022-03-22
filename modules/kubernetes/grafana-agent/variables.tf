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

variable "extra_namespaces" {
  description = "namespace to disable in grafana"
  type        = list(string)
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

variable "namespace_include" {
  description = "A list of the namespaces that kube-state-metrics should create metrics for"
  type        = list(string)

  validation {
    condition     = length(var.namespace_include) > 0
    error_message = "The namespace_include needs to at least contain one namespace in the list."
  }
}
variable "ingress_nginx_metrics" {
  description = "Will be set with extra_namespaces in main.tf "
  type        = bool
  default     = false
}
