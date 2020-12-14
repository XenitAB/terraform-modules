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
    vpc_cidr_block    = string
    public_cidr_block = string
  })
}

variable "dns_zone" {
  description = "The DNS Zone that will be used by the EKS cluster"
  type        = string
}
