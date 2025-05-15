terraform {}

module "prometheus" {
  source = "../../../modules/kubernetes/prometheus"

  aks_name            = "aks"
  cluster_id          = "foo"
  cluster_name        = "aks1"
  environment         = "dev"
  location_short      = "we"
  oidc_issuer_url     = "url"
  region              = "sc"
  remote_write_url    = "https://my-remote-writer.com"
  resource_group_name = "rg-name"
  tenant_name         = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
