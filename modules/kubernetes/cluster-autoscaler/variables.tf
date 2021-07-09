variable "cluster_name" {
  description = "Name of Kubernetes cluster"
  type        = string
}

variable "cloud_provider" {
  description = "Name of cloud provider cluster autoscaler will be deployed in"
  type        = string
}

variable "aws_config" {
  description = "AWS specific configuration"
  type = object({
    role_arn = string,
    region   = string
  })
  default = {
    role_arn = "",
    region   = ""
  }
}
