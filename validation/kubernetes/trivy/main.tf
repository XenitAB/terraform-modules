terraform {}

module "trivy" {
  source = "../../../modules/kubernetes/trivy"

  aks_managed_identity            = "id"
  cluster_id                      = "foo"
  environment                     = "dev"
  location                        = "location"
  location_short                  = "we"
  oidc_issuer_url                 = "url"
  resource_group_name             = "rg-name"
  volume_claim_storage_class_name = "name"
}
