terraform {}

provider "kubernetes" {}

provider "helm" {}

module "argocd" {
  source = "../../../modules/kubernetes/argocd"

  argocd_config = {
    global_domain        = "example.com"
    ingress_whitelist_ip = "10.0.2.0"
    tenant               = "example.onmicrosoft.com"
    oidc_issuer_url      = "https://issuer-url"
  }
  cluster_id               = "cluster-id"
  resource_group_name      = "rg_name"
  location                 = "location"
  core_resource_group_name = "rg-core"
  key_vault_name           = "my-keyvault"
}