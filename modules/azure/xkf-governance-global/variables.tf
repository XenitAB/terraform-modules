variable "cloud_provider" {
  description = "Current provider"
  type        = string
  validation {
    condition     = can(regex("azure|aws", var.cloud_provider))
    error_message = "Cloud provider is not valid."
  }
}

variable "environment" {
  description = "The environemnt"
  type        = string
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
}

variable "namespaces" {
  description = "The Kubernetes namespaces to create Azure AD groups for"
  type = list(
    object({
      name                    = string
      delegate_resource_group = bool
    })
  )
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "group_name_prefix" {
  description = "Prefix for Azure AD groups"
  type        = string
}

variable "azure_ad_group_prefix" {
  description = "Prefix for Azure AD Groups"
  type        = string
  default     = "az"
}

