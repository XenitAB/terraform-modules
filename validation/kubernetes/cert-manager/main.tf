terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  cloud_provider = "azure"
  notification_email = "example@example.com"
}
