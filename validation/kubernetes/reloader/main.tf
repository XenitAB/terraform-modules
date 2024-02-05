terraform {}

provider "kubernetes" {}

provider "helm" {}

module "reloader" {
  source = "../../../modules/kubernetes/reloader"

  cluster_id = "foo"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
