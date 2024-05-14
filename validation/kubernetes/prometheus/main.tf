terraform {}

module "prometheus" {
  source = "../../../modules/kubernetes/prometheus"

  aks_name            = "aks"
  cluster_id          = "foo"
  cluster_name        = "aks1"
  environment         = "dev"
  location_short      = "we"
  oidc_issuer_url     = "url"
  region              = "sc"
  remote_write_url    = "https://my-remote-writer.com"
  resource_group_name = "rg-name"
}
