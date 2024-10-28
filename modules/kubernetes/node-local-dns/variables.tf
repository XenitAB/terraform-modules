variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "dns_ip" {
  description = "Central DNS IP"
  type        = string
}

variable "coredns_upstream" {
  type        = bool
  description = "Should coredns be used as the last route instead of upstream dns?"
  default     = false
}
variable "cilium_enabled" {
  description = "If enabled, will use Azure CNI with Cilium instead of kubenet"
  type        = bool
  default     = false
}