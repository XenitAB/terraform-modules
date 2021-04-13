terraform {}

provider "kubernetes" {}

provider "helm" {}

module "ingress_healthz" {
  source = "../../../modules/kubernetes/ingress-healthz"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  environment = "dev"
  dns_zone = "foo.bar.com"
}
