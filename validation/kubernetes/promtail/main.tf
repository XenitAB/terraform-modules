terraform {}

provider "kubernetes" {}

provider "helm" {}

module "prometheus" {
  source = "../../../modules/kubernetes/promtail"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  loki_address   = "http://loki-gateway/loki/api/v1/push"
  cloud_provider = "azure"
}
