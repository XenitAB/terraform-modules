variable "cloud_provider" {
  description = "Cloud provider used for falco"
  type        = string
}
variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}
