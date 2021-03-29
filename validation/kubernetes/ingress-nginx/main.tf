terraform {}

provider "kubernetes" {}

provider "helm" {}

module "ingress_nginx" {
  source = "../../../modules/kubernetes/ingress-nginx"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  http_snipet = "foo"
}
