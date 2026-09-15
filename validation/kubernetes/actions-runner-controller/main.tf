terraform {}

provider "kubernetes" {}

provider "helm" {}

module "actions_runner_controller" {
  source = "../../../modules/kubernetes/actions-runner-controller"

  cluster_id  = "foobar"
  environment = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
  location            = "location"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  tenant_name         = "foo"
}
