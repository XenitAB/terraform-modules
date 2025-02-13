terraform {}

module "fluxcd" {
  source = "../../../modules/kubernetes/fluxcd"

  environment = "dev"
  cluster_id  = "foobar"
  git_provider = {
    organization        = "acme"
    type                = "azuredevops"
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