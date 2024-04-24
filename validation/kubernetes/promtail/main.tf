terraform {}

provider "kubernetes" {}

provider "helm" {}

module "promtail" {
  source = "../../../modules/kubernetes/promtail"

  loki_address        = "http://loki-gateway/loki/api/v1/push"
  cluster_id          = "test"
  cluster_name        = "c1"
  environment         = "prod"
  region              = "sc"
  excluded_namespaces = ["ns1", "ns2"]

}
