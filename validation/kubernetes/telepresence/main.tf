terraform {}

module "telepresence" {
  source = "../../../modules/kubernetes/telepresence"

  cluster_id = "we-dev-aks"
  telepresence_config = {
    allow_conflicting_subnets = []
    client_rbac = {
      create     = true
      namespaced = true
      namespaces = ["ambassador"]
      subjects   = []
    }
    manager_rbac = {
      create     = true
      namespaced = true
      namespaces = []
    }
  }
}