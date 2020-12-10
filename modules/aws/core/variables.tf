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

variable "vpc_config" {
  description = "The configuration for the VPC"
  type = object({
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    subnets = list(object({
      name       = string
      cidr_block = string
      az         = number
      eksName    = string
    }))
  })
}
