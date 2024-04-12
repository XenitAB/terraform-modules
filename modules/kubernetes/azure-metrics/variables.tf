variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

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

variable "podmonitor_loadbalancer" {
  type        = bool
  description = "Enable podmonitor for loadbalancers?"
  default     = true
}

variable "podmonitor_kubernetes" {
  type        = bool
  description = "Enable podmonitor for kubernetes?"
  default     = true
}
