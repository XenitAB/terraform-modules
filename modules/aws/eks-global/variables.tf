variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "Common name for the environment"
  type        = string
}

variable "region" {
  description = "The AWS region to configure"
  type = object({
    location       = string
    location_short = string
  })
}
