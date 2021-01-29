variable "datadog_host" {
  description = "Datadog host to send events to"
  type        = string
  default     = "https://api.datadoghq.eu"
}

variable "datadog_api_key" {
  description = "Datadog api key used to authenticate"
  type        = string
}
