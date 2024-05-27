terraform {}

provider "kubernetes" {}

provider "helm" {}

module "control-plane-logs" {
  source = "../../../modules/kubernetes/control-plane-logs"

  aks_name            = "aks"
  cluster_id          = "foo"
  environment         = "dev"
  location_short      = "we"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
}
