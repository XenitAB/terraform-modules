terraform {}

provider "kubernetes" {}

provider "helm" {}

module "goldpinger" {
  source = "../../../modules/kubernetes/goldpinger"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }
}
