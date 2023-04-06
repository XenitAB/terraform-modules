variable "path_kustomization" {
  description = "Path to datadog kustomization"
  type        = string
}

variable "path_platform" {
  description = "Path to datadog platform flux"
  type        = string
}
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
  description = "API key to upload data to Datadog"
  type        = string
}

variable "app_key" {
  description = "APP key to configure data like alarms in Datadog"
  type        = string
}

variable "namespace_include" {
  description = "The namespace that should be checked by Datadog, example: kube_namespace:NAMESPACE kube_namespace:NAMESPACE2"
  type        = list(string)
}

variable "apm_ignore_resources" {
  description = "The resources that shall be excluded from APM"
  type        = list(string)
  default     = []
}
