terraform {}

provider "kubernetes" {}

provider "helm" {}

module "external_secrets" {
  source = "../../../modules/kubernetes/external-secrets"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }
}
