terraform {}

provider "kubernetes" {}

provider "helm" {}

module "kyverno" {
  source = "../../../modules/kubernetes/kyverno"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  excluded_namespaces = ["foobar"]
}
