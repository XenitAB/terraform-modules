terraform {}

provider "kubernetes" {}

provider "helm" {}

module "prometheus" {
  source = "../../../modules/kubernetes/promtail"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  loki_address        = "http://loki-gateway/loki/api/v1/push"
  cloud_provider      = "azure"
  cluster_name        = "c1"
  environment         = "prod"
  tenant_id           = "t1"
  excluded_namespaces = ["ns1", "ns2"]

}
