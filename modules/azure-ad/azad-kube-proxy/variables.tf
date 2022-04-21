variable "proxy_url" {
  description = "The URL to the azad-kube-proxy, will be used for identified_uris and proxy_url tag."
  type        = string
}

variable "display_name" {
  description = "The display name for the Azure AD application."
  type        = string
}

variable "cluster_name" {
  description = "The name that will show up in the discovery and be used as the context for the kubeconfig."
  type        = string
}
