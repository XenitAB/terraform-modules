terraform {}

module "azure_metrics" {
  source = "../../../modules/kubernetes/azure-metrics"

  aks_managed_identity = "id"
  aks_name             = "aks"
  aks_name_suffix      = 1
  environment          = "dev"
  cluster_id           = "foo"
  location             = "location"
  location_short       = "we"
  oidc_issuer_url      = "url"
  resource_group_name  = "rg-name"
  subscription_id      = "0987"
  tenant_name          = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"

  }
}
