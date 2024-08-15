terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana_agent" {
  source = "../../../modules/kubernetes/grafana-alloy"

  cluster_id                            = "foo"
  cluster_name                          = "aks1"
  oidc_issuer_url                       = "url"
  resource_group_name                   = "rg-name"
  environment                           = "dev"
  namespace_include                     = ["foobar"]
  grafana_alloy_config                  = {
    grafana_otelcol_auth_basic_username = "foo"
    grafana_otelcol_exporter_endpoint   = "bar"
    azure_key_vault_name                = "foobar"
    keyvault_secret_name                = "barfoo"
  }
}
