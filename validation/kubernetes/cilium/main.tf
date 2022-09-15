terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cilium" {
  source = "../../../modules/kubernetes/cilium"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

}
