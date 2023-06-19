variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "cloud_provider" {
  description = "Cloud provider to use."
  type        = string
  default     = "azure"
}

variable "exclude_namespaces" {
  description = "Namespaces to exclude from admission and mutation."
  type        = list(string)
}
