variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "core_name" {
  description = "The commonName for the core infrastructure"
  type        = string
}
