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

variable "input_depends_on" {
  description = "Input dependency for module"
  type        = any
  default     = {}
}
