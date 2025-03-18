variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "status_config_map_namespace" {
  description = "Namespace where Cluster Autoscaler status ConfigMap is created"
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type = string
}
