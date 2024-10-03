terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana_alloy" {
  source = "../../../modules/kubernetes/grafana-alloy"

  cluster_id           = "foo"
  oidc_issuer_url      = "url"
  resource_group_name  = "rg-name"
  environment          = "dev"
  aks_name             = "fooburrito"
  location_short       = "foob"
  grafana_alloy_config = "barfoo"
}
