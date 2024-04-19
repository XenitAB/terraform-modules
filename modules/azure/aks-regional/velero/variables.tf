variable "location_short" {
  description = "The Azure region short name"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "The name to use for the deploy"
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "aks_managed_identity" {
  description = "AKS Azure AD managed identity"
  type        = string
}
