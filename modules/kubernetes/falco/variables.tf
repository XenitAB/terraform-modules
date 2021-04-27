variable "environment" {
  description = "Variable to add to custom fields"
  type        = string
}

variable "minimum_priority" {
  description = "Minimum priority required before being exported"
  type        = string
  default     = "INFO"
}

