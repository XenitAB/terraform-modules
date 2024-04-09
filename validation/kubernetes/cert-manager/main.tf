terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  notification_email = "example@example.com"
}
