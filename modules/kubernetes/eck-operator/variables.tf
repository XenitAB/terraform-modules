
variable "eck_managed_namespaces" {
  description = "A list of namespaces where the operator will manage the ECK resources"
  type        = list(string)
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type = string
}