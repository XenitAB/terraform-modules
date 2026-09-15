terraform {}

provider "kubernetes" {}

provider "helm" {}

module "actions_runner_controller" {
  source = "../../../modules/kubernetes/actions-runner-controller"

  aks_name    = "aks"
  cluster_id  = "foobar"
  environment = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
  location        = "location"
  location_short  = "loc"
  oidc_issuer_url = "url"
  azure_tenant_id = "00000000-0000-0000-0000-000000000000"
  key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-name/providers/Microsoft.KeyVault/vaults/kv-test"
  arc_runner_set_config = {
    runner_scale_set_name      = "test-runners"
    github_config_url          = "https://github.com/foo/bar"
    github_app_id              = "1"
    github_app_installation_id = "2"
    key_vault_name             = "kv-test"
  }
  resource_group_name = "rg-name"
  tenant_name         = "foo"
}
