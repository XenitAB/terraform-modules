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
