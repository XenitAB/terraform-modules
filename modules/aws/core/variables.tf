variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "Common name for the environment"
  type        = string
}

variable "vpc_config" {
  description = "The configuration for the VPC"
  type = object({
    cidr_block = string
    public_subnet = object({
      cidr_block = string
      tags       = map(string)
    })
  })
}

variable "dns_zone" {
  description = "The DNS Zone that will be used by the EKS cluster"
  type        = string
}
