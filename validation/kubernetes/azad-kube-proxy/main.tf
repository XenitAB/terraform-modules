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

  azure_ad_app = {
    client_id     = "00000000-0000-0000-0000-000000000000"
    client_secret = "00000000-0000-0000-0000-000000000000"
    tenant_id     = "00000000-0000-0000-0000-000000000000"
  }
}
