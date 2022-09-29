variable "environment" {
  type        = string
  description = "Environment ingress-healthz is deployed in"
}

variable "dns_zone" {
  type        = string
  description = "DNS Zone to create ingress sub domain under"
}

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}
variable "location_short" {
  description = "Region short name"
  type        = string
  default     = ""
}
variable "public_private_enabled" {
  description = "Is public private nginx enabled"
  type        = bool
  default     = true
}
