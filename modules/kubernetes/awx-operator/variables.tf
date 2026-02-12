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

variable "awx_config" {
  description = "AWX Operator configuration"
  type = object({
    target_revision = optional(string, "2.19.1")
    create_instance = optional(bool, true)
    instance_name   = optional(string, "awx")
    service_type    = optional(string, "ClusterIP")
    ingress_type    = optional(string, "none")  # create an own gateway-api gateway with httproutes
    hostname        = optional(string, "")
  })
  default = {}
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
