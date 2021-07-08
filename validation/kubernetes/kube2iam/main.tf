terraform {}

provider "kubernetes" {}

provider "helm" {}

module "kube2iam" {
  source = "../../../modules/kubernetes/kube2iam"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
