terraform {}

module "gatekeeper" {
  source                         = "../../../modules/kubernetes/gatekeeper"
  azure_service_operator_enabled = false
  cluster_id                     = "foobar"
  exclude_namespaces             = []
}
