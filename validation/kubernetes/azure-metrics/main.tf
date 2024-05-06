terraform {}

module "azure_metrics" {
  source = "../../../modules/kubernetes/azure-metrics"

  cluster_id          = "foo"
  location            = "location"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  subscription_id     = "0987"
}
