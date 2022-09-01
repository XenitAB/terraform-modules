variable "chart" {
  description = "Helm Chart OCI URI"
  type        = string
}

variable "chart_name" {
  description = "Helm Chart repository"
  type        = string
}

variable "chart_version" {
  description = "Helm Chart repository"
  type        = string
}

variable "values" {
  description = "Extra values to pass when templating"
  type        = map(any)
  default     = {}
}
