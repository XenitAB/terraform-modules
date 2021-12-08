variable "client_id" {
  description = "The client_id for aadpodidentity with access to AZ specific metrics"
  type        = string
}

variable "resource_id" {
  description = "The resource_id for aadpodidentity to the resource"
  type        = string
}

variable "subscription_id" {
  description = "The subscription id where your kubernetes cluster is deployed"
  type        = string
}
