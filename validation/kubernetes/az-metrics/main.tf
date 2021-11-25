terraform {}

provider "kubernetes" {}

provider "helm" {}

module "az_metrics" {
  source = "../../../modules/kubernetes/az-metrics"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  client_id   = "1234"
  resource_id = "5678"
}
