variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "exclude_namespaces" {
  description = "Namespaces to exclude from admission and mutation."
  type        = list(string)
}
