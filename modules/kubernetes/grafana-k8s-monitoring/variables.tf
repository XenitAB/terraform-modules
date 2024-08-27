
variable "grafana_k8s_monitor_config" {
  description = "Configuration for the username and password"
  type = object({
    grafana_cloud_prometheus_username = string
    grafana_cloud_prometheus_host     = string
    grafana_cloud_loki_host           = string
    grafana_cloud_loki_username       = string
    grafana_cloud_tempo_host          = string
    grafana_cloud_tempo_username      = string
  })
  default = {
    grafana_cloud_prometheus_username = ""
    grafana_cloud_prometheus_host     = ""
    grafana_cloud_loki_host           = ""
    grafana_cloud_loki_username       = ""
    grafana_cloud_tempo_host          = ""
    grafana_cloud_tempo_username      = ""
  }
}

variable "cluster_name" {
  description = "Unique identifier of the cluster across instances."
  type        = string
}
variable "grafana_cloud_api_key" {
  description = "API key for connecting to grafana cloud."
  type        = string
}
variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}
