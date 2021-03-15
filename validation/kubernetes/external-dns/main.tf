terraform {}

provider "kubernetes" {}

provider "helm" {}

module "external_dns" {
  source = "../../../modules/kubernetes/external-dns"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  dns_provider = "azure"
  txt_owner_id = "dev-aks1"
  azure_config = {
    tenant_id       = "id"
    subscription_id = "id"
    resource_group  = "name"
    client_id       = "id"
    resource_id     = "id"
  }
}
