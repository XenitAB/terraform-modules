terraform {}

provider "kubernetes" {}

provider "helm" {}

module "reloader" {
  source = "../../../modules/kubernetes/reloader"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
