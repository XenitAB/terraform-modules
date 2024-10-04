terraform {}

provider "kubernetes" {}

provider "helm" {}

module "azad_kube_proxy" {
  source = "../../../modules/kubernetes/azad-kube-proxy"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  fqdn       = "k8s.example.com"
  cluster_id = "test"
  environment = "test"
  location = "test"
  location_short = "we"
  resource_group_name = "test"
  dns_zones = ["test"]
  name = "core"
  key_vault_id = "foo"
  key_vault_name = "foo"
  oidc_issuer_url = "test.com"
}
