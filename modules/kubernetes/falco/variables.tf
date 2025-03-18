variable "cilium_enabled" {
  description = "If enabled, will use Azure CNI with Cilium instead of kubenet"
  type        = bool
  default     = false
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}