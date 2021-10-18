variable "cluster_name" {
  description = "Name of the cluster to use in New Relic"
  type        = string
}

variable "license_key" {
  description = "License key used to authenticate with New Relic"
  type        = string
}

variable "namespace_include" {
  description = "The namespace that should be included in New Relic metrics and logs"
  type        = list(string)
}
