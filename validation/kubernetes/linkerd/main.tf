terraform {}

provider "kubernetes" {}

provider "helm" {}

module "linkerd" {
  source = "../../../modules/kubernetes/linkerd"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
