variable "remote_write_urls" {
  description = "the remote write urls"
  type = object({
    metrics = string
    logs    = string
  })
  default = {
    metrics = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push"
    logs    = "https://logs-prod-eu-west-0.grafana.net/loki/api/v1/push"
  }
}

variable "credentials" {
  description = "grafana-agent credentials"
  type = object({
    metrics_username = string
    metrics_password = string
    logs_username    = string
    logs_password    = string
  })
  sensitive = true
}

variable "cluster_name" {
  description = "the cluster name"
  type        = string
}

variable "environment_short" {
  description = "the short name for the environment"
  type        = string
}
