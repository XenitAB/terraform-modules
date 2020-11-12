# Configure backend
terraform {
  backend "azurerm" {}
}

# Configure the Azure Provider
provider "azurerm" {
  version = "=2.14.0"
  features {}
}

# Configure the Azure AD Provider
provider "azuread" {
  version = "=0.10.0"
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  load_config_file       = "false"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    load_config_file       = "false"
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate)
  }
}

data "terraform_remote_state" "aksGlobal" {
  backend   = "azurerm"
  workspace = var.environmentShort

  config = {
    resource_group_name  = var.REMOTE_STATE_RESOURCEGROUP
    storage_account_name = var.REMOTE_STATE_STORAGEACCOUNTNAME
    container_name       = "tfstate-tf-aks-global"
    key                  = var.REMOTE_STATE_BACKENDKEY
  }
}
