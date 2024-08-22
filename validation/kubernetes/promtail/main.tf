terraform {}

provider "kubernetes" {}

provider "helm" {}

module "promtail" {
  source = "../../../modules/kubernetes/promtail"

  aks_name              = "aks"
  cluster_id            = "foo"
  cluster_name          = "c1"
  environment           = "dev"
  excluded_namespaces   = ["ns1", "ns2"]
  location_short        = "we"
  loki_address          = "http://loki-gateway/loki/api/v1/push"
  oidc_issuer_url       = "url"
  region                = "sc"
  resource_group_name   = "rg-name"
  grafana_cloud_address = "bar"
}
