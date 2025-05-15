terraform {}

module "gatekeeper" {
  source                         = "../../../modules/kubernetes/gatekeeper"
  azure_service_operator_enabled = false
  cluster_id                     = "foobar"
  exclude_namespaces             = []
  tenant_name                    = "foo"
  environment                    = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
