locals {
  host       = yamldecode(azurerm_kubernetes_cluster.this.kube_config_raw)["clusters"][0].cluster.server
  auth_data  = yamldecode(azurerm_kubernetes_cluster.this.kube_config_raw)["clusters"][0].cluster.certificate-authority-data
  apiVersion = yamldecode(azurerm_kubernetes_cluster.this.kube_config_raw)["users"][0].user.exec.apiVersion
  args       = yamldecode(azurerm_kubernetes_cluster.this.kube_config_raw)["users"][0].user.exec.args
  command    = yamldecode(azurerm_kubernetes_cluster.this.kube_config_raw)["users"][0].user.exec.command
}


output "kube_config" {
  description = "Kube config for the created AKS cluster"
  sensitive   = true
  value = {
    host                   = local.host
    cluster_ca_certificate = base64decode(local.auth_data)
    api_version            = local.apiVersion
    args                   = local.args
    command                = local.command
  }
}
