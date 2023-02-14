terraform {}

provider "kubernetes" {}

provider "helm" {}

module "trivy" {
  source = "../../../modules/kubernetes/trivy"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  cloud_provider = "bar"
}
