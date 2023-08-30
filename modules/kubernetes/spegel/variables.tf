variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "private_registry" {
  description = "Private registry to add to Spegels mirror list."
  type        = string
  default     = ""
}
