terraform {}

provider "kubernetes" {}

provider "helm" {}

module "prometheus" {
  source = "../../../modules/kubernetes/prometheus"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  cluster_id   = "foo"
  cluster_name = "aks1"
  dns_zones    = ["a.com"]
  environment  = "dev"
  #excluded_namespaces = ["ns1", "ns2"]
  location       = "location"
  location_short = "we"
  #loki_address        = "http://loki-gateway/loki/api/v1/push"
  oidc_issuer_url     = "url"
  region              = "sc"
  remote_write_url    = "https://my-remote-writer.com"
  resource_group_name = "rg-name"
}
