terraform {}

module "datadog" {
  source = "../../../modules/kubernetes/datadog"

  apm_ignore_resources = ["foo"]
  cluster_id           = "foo"
  environment          = "dev"
  key_vault_id         = "id"
  location             = "location"
  location_short       = "we"
  namespace_include    = ["ns1", "ns2"]
  oidc_issuer_url      = "url"
  resource_group_name  = "rg-name"
}
