terraform {}

provider "kubernetes" {}

provider "helm" {}

module "velero" {
  source = "../../../modules/kubernetes/velero"

  aks_managed_identity = "id"
  azure_config = {
    storage_account_name      = "name"
    storage_account_container = "name"
  }
  cluster_id          = "we-dev-aks1"
  environment         = "dev"
  location            = "we"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  subscription_id     = "id"
  unique_suffix       = "1234"
  tenant_name         = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
