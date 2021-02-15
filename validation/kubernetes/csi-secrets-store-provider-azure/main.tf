terraform {}

provider "kubernetes" {}

provider "helm" {}

module "csi_secrets_store_provider_azure" {
  source = "../../../modules/kubernetes/csi-secrets-store-provider-azure"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }
}
