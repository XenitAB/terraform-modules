terraform {}

module "external_dns" {
  source = "../../../modules/kubernetes/external-dns"

  cluster_id   = "foo"
  dns_provider = "azure"
  dns_zones = {
    "a.com" = "id"
  }
  environment                = "dev"
  global_resource_group_name = "global"
  location                   = "location"
  location_short             = "we"
  oidc_issuer_url            = "url"
  resource_group_name        = "rg-name"
  subscription_id            = "id"
  txt_owner_id               = "dev-aks1"
  sources                    = ["ingress", "service"]
  extra_args                 = []
}
