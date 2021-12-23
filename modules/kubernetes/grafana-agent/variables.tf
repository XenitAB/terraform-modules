variable "remote_write_urls" {
  description = "the remote write urls"
  type = object({
    metrics = string
    logs    = string
    traces  = string
  })
  default = {
    metrics = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push"
    logs    = "https://logs-prod-eu-west-0.grafana.net/loki/api/v1/push"
    traces  = "tempo-eu-west-0.grafana.net:443"
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
