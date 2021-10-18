terraform {}

provider "kubernetes" {}

provider "helm" {}

module "new_relic" {
  source = "../../../modules/kubernetes/new-relic"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  cluster_name = "foo"
  license_key  = "bar"
}
