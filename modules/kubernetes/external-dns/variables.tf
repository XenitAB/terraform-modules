variable "dns_provider" {
  description = "DNS provider to use."
  type = string
}

variable "sources" {
  description = "k8s resource types to observe"
  type = list(string)
  default = ["ingress"]
}
