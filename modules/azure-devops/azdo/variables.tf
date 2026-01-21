variable "azuredevops_project" {
  description = "The name of the azure devops project"
  type        = string
}

variable "azuredevops_organization" {
  description = "The name of the azure devops project"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "location" {
  description = "The name of the location"
  type        = string
}

variable "location_short" {
  description = "The short name of the location"
  type        = string
}

variable "subscription_name" {
  description = "The name of the subscription"
  type        = string
}

variable "core_name" {
  description = "The name of the core infra"
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
}

variable "azdo_pat_name" {
  description = "Azure DevOps PAT name that is stored in a azure key-vault"
  type        = string
  default     = "azure-devops-pat"
}

variable "display_name" {
  description = "The display name for the Azure AD application."
  type        = string
}
