variable "environment" {
  description = "The environemnt"
  type        = string
}

variable "name" {
  description = "Name for the deployment"
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
}
