terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana_alloy" {
  source = "../../../modules/kubernetes/grafana-alloy"

  cluster_id          = "foo"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  environment         = "dev"
  aks_name            = "fooburrito"
  location_short      = "foob"
  cluster_name        = "awesome_cluster"
  tenant_name         = "foo"
  namespace_include   = ["footest-namespace"]

  azure_config = {
    azure_key_vault_name = "key-vault-name"
    keyvault_secret_name = "secret-name"
  }
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
