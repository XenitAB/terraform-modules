variable "cloud_provider" {
  description = "Name of cloud provider cluster autoscaler will be deployed in"
  type = string
}

variable "cluster_name" {
  description = "Name of Kubernetes cluster"
  type = string
}

variable "aws_region" {
  description = "Region if deployed in AWS"
  type = string
  default = ""
}
