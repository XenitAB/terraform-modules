variable "azure_ad_app" {
  description = "The Azure AD Application config for azad-kube-proxy"
  type = object({
    client_id     = string
    client_secret = string
    tenant_id     = string
  })
  sensitive = true
}

variable "dashboard" {
  description = "What dashboard to use with azad-kube-proxy"
  type        = string
  default     = "k8dash"
  validation {
    condition     = var.dashboard == "none" || var.dashboard == "k8dash"
    error_message = "Supported inputs are 'none' and 'k8dash'."
  }
}

variable "k8dash_config" {
  description = "The k8dash configuration if chosen as dashboard"
  type = object({
    client_id     = string
    client_secret = string
    scope         = string
  })
  sensitive = true
  default = {
    client_id     = ""
    client_secret = ""
    scope         = ""
  }
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