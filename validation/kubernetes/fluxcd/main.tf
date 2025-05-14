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
  git_provider = {
    organization = "acme"
    type         = "azuredevops"
    azure_devops = {
      pat = "string"
    }
  }
  bootstrap = {
    repository = "my-repo"
  }
  namespaces = [
    {
      name = "tenant-1"
      fluxcd = {
        provider    = "azuredevops"
        project     = "project-1"
        repository  = "repo-2"
        create_crds = false
      }
    }
  ]
}