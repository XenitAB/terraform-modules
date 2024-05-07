terraform {}

module "trivy" {
  source = "../../../modules/kubernetes/trivy"

  aks_managed_identity            = "id"
  aks_name                        = "aks"
  cluster_id                      = "foo"
  environment                     = "dev"
  location                        = "location"
  location_short                  = "we"
  oidc_issuer_url                 = "url"
  resource_group_name             = "rg-name"
  unique_suffix                   = "1234"
  volume_claim_storage_class_name = "name"
}
