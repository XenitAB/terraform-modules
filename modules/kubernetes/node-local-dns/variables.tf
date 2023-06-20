variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "dns_ip" {
  description = "Central DNS IP"
  type        = string
}
