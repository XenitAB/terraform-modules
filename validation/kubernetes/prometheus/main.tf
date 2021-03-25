terraform {}

provider "kubernetes" {}

provider "helm" {}

module "prometheus" {
  source = "../../../modules/kubernetes/prometheus"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
