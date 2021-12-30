terraform {}

provider "kubernetes" {}

provider "helm" {}

module "vpa" {
  source = "../../../modules/kubernetes/vpa"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
