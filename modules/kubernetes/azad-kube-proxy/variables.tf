variable "azure_ad_app" {
  description = "The Azure AD Application config for azad-kube-proxy"
  type = object({
    client_id     = string
    client_secret = string
    tenant_id     = string
  })
  sensitive = true
}

variable "allowed_ips" {
  description = "The external IPs allowed through the ingress to azad-kube-proxy"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "fqdn" {
  description = "The name to use with the ingress (fully qualified domain name). Example: k8s.example.com"
  type        = string
}

variable "azure_ad_group_prefix" {
  description = "The Azure AD group prefix to filter for"
  type        = string
  default     = ""
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "private_ingress_enabled" {
  description = "If true will create a public and private ingress controller. Otherwise only a public ingress controller will be created."
  type        = bool
  default     = false
}

variable "use_private_ingress" {
  description = "If true, private ingress will be used by azad-kube-proxy"
  type        = bool
  default     = false
}