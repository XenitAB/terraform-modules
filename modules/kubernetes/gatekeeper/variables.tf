variable "azure_service_operator_enabled" {
  description = "If Azure Service Operator should be enabled"
  type        = bool
  default     = false
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "exclude_namespaces" {
  description = "Namespaces to exclude from admission and mutation."
  type        = list(string)
}

variable "mirrord_enabled" {
  description = "If Gatekeeper validations should make an exemption for mirrord agent."
  type        = bool
  default     = false
}

variable "telepresence_enabled" {
  description = "If Gatekeeper validations should make an exemption for telepresence agent."
  type        = bool
  default     = false
}

