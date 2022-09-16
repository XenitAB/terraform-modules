terraform {}

provider "kubernetes" {}

provider "helm" {}

module "control-plane-logs" {
  source = "../../../modules/kubernetes/control-plane-logs"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  cloud_provider   = "azure"
}
