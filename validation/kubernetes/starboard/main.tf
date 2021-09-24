terraform {}

provider "kubernetes" {}

provider "helm" {}

module "starboard" {
  source = "../../../modules/kubernetes/starboard"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  cloud_provider = "bar"
}
