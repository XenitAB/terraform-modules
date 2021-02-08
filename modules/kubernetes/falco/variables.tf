variable "environment" {
  description = "Variable to add to custom fields"
  type        = string
}

variable "minimum_priority" {
  description = "Minimum priority required before being exported"
  type        = string
  default     = "INFO"
}

variable "datadog_site" {
  description = "Datadog host to send events to"
  type        = string
  default     = "api.datadoghq.eu"
}

variable "datadog_api_key" {
  description = "Datadog api key used to authenticate"
  type        = string
}
