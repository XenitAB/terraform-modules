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

variable "mirrord enabled" {
  description = "If Gatekeeper validations should make an exemption for mirrord agent."
  type        = bool
  default     = false
}

variable "telepresence enabled" {
  description = "If Gatekeeper validations should make an exemption for telepresence agent."
  type        = bool
  default     = false
}

