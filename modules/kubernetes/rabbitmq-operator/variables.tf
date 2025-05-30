variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "rabbitmq_config" {
  description = "The RabbitMQ operator configuration"
  type = object({
    min_available           = optional(number, 0)
    replica_count           = optional(number, 1)
    network_policy_enabled  = optional(bool, false)
    spot_instances_enabled  = optional(bool, true)
    tology_operator_enabled = optional(bool, false)
    watch_namespaces        = optional(list(string), [])
  })
  default = {}
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}