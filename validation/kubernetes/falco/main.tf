terraform {}

provider "kubernetes" {}

provider "helm" {}

module "falco" {
  source = "../../../modules/kubernetes/falco"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }
}
