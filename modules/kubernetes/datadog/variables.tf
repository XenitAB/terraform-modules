variable "datadog_site" {
  description = "Site to connect Datadog agent"
  type        = string
  default     = "datadoghq.eu"
}

variable "environment" {
  description = "Cluster environment"
  type        = string
}

variable "location" {
  description = "Cluster location"
  type        = string
}

variable "api_key" {
  description = "API key to authenticate to Datadog"
  type        = string
}

variable "container_include" {
  description = "The container/ns that should be checked by Datadog"
  type        = string
}
