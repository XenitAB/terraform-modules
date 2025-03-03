terraform {}

provider "kubernetes" {}

provider "helm" {}

module "argocd" {
  source = "../../../modules/kubernetes/argocd"

  argocd_config = {
    global_domain        = "example.com"
    ingress_whitelist_ip = "10.0.2.0"
    tenant               = "example.onmicrosoft.com"
  }
}