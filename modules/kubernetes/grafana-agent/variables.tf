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
variable "extra_namespaces" {
  type        = list(string)
  description = "List of namespaces that should be enabled"
  default     = ["ingress-nginx"]
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

variable "namespace_include" {
  description = "A list of the namespaces that kube-state-metrics and kubelet metrics"
  type        = list(string)

  validation {
    condition     = length(var.namespace_include) > 0
    error_message = "The namespace_include needs to at least contain one namespace in the list."
  }
}

variable "include_kubelet_metrics" {
  description = "If kubelet metrics shall be included for the namespaces in 'namespace_include'"
  type        = bool
  default     = false
}
