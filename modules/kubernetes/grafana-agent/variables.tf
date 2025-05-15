variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "cluster_name" {
  description = "the cluster name"
  type        = string
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

variable "environment" {
  description = "the name of the environment"
  type        = string
}

variable "extra_namespaces" {
  type        = list(string)
  description = "List of namespaces that should be enabled"
  default     = ["ingress-nginx"]
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "include_kubelet_metrics" {
  description = "If kubelet metrics shall be included for the namespaces in 'namespace_include'"
  type        = bool
  default     = false
}

variable "namespace_include" {
  description = "A list of the namespaces that kube-state-metrics and kubelet metrics"
  type        = list(string)
}

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

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
