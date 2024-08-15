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
