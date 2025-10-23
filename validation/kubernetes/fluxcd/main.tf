terraform {}

module "fluxcd" {
  source = "../../../modules/kubernetes/fluxcd"

  oidc_issuer_url      = "azure.https.issuer"
  resource_group_name  = "rg-ilove-you"
  acr_name_override    = "IDK"
  aks_managed_identity = "someid"
  aks_name             = "foo"
  location             = "westuerope"
  location_short       = "idk"
  environment          = "dev"
  cluster_id           = "foobar"
  tenant_name          = "foo"
  fleet_infra_config = {
    git_repo_url        = "https://dev.azure.com/acme/project-1/_git/repo-1"
    k8s_api_server_url  = "https://k8s-api-server-url"
    argocd_project_name = "infra"
    argocd_app_name     = "fluxcd"
  }
  git_provider = {
    organization = "acme"
    type         = "azuredevops"
  }
  namespaces = [
    {
      name = "tenant-1"
      fluxcd = {
        provider    = "github"
        project     = "project-1"
        repository  = "repo-2"
        create_crds = false
      }
    }
  ]
}