variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "telepresence_config" {
  description = "Config to use when deploying traffic manager to the cluster"
  type = object({
    allow_conflicting_subnets = optional(list(string), [])
    client_rbac = object({
      create     = bool
      namespaced = bool
      namespaces = optional(list(string), ["ambassador"])
      subjects   = optional(list(string), [])
    })
    manager_rbac = object({
      create     = bool
      namespaced = bool
      namespaces = optional(list(string), [])
    })
  })
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
