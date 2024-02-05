terraform {}

module "gatekeeper" {
  source             = "../../../modules/kubernetes/gatekeeper"
  cluster_id         = "foobar"
  exclude_namespaces = []
}
