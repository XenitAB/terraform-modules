variable "REMOTE_STATE_BACKENDKEY" {
  description = "The Backend Key for the remote state"
  type        = string
}

variable "REMOTE_STATE_RESOURCEGROUP" {
  description = "The Resource Group for the remote state"
  type        = string
}

variable "REMOTE_STATE_STORAGEACCOUNTNAME" {
  description = "The Storage Account Name for the remote state"
  type        = string
}


variable "location" {
  description = "The Azure region to create things in."
  type        = string
}

variable "locationShort" {
  description = "The Azure region short name."
  type        = string
}

variable "environmentShort" {
  description = "The environment (short name) to use for the deploy"
  type        = string
}

variable "commonName" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "subscriptionCommonName" {
  description = "The commonName for the subscription"
  type        = string
}

variable "aksCommonName" {
  description = "The commonName for the aks clusters"
  type        = string
}

variable "coreCommonName" {
  description = "The commonName for the core infrastructure"
  type        = string
}


variable "k8sSaNamespace" {
  description = "The namespaced used to store service accounts."
  type        = string
}

variable "aksConfiguration" {
  description = "The Azure Kubernetes Service (AKS) configuration"
  type = object({
    kubernetes_version = string
    sku_tier           = string
    default_node_pool = object({
      orchestrator_version = string
      vm_size              = string
      min_count            = number
      max_count            = number
      node_labels          = map(string)
    })
    additional_node_pools = list(object({
      name                 = string
      orchestrator_version = string
      vm_size              = string
      min_count            = number
      max_count            = number
      node_taints          = list(string)
      node_labels          = map(string)
    }))
  })
}

variable "azdo_git_proxy" {
  description = "Configuration for Azure DevOps git proxy"
  type = object({
    chart             = string
    repository        = string
    version           = string
    azdo_domain       = string
    azdo_organization = string
  })
}
