terraform {}

provider "kubernetes" {}

provider "helm" {}

module "control-plane-logs" {
  source = "../../../modules/kubernetes/control-plane-logs"

  aks_name            = "aks"
  cluster_id          = "foo"
  environment         = "dev"
  location_short      = "we"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  tenant_name         = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"

  }
}
