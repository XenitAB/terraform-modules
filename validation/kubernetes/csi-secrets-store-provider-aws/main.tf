terraform {}

provider "kubernetes" {}

provider "helm" {}

module "csi_secrets_store_provider_aws" {
  source = "../../../modules/kubernetes/csi-secrets-store-provider-aws"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
