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
  tenant_name = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}