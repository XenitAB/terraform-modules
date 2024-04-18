terraform {}

module "trivy" {
  source = "../../../modules/kubernetes/trivy"

  client_id                       = "id"
  cluster_id                      = "id"
  resource_id                     = "id"
  volume_claim_storage_class_name = "name"
}
