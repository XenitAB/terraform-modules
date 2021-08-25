terraform {}

provider "helm" {}

module "fluxcd_v1" {
  source = "../../../modules/kubernetes/fluxcd-v1"

  providers = {
    helm = helm
  }

  azure_devops_pat = "foo"
  azure_devops_org = "bar"
  environment      = "dev"

  namespaces = [
    {
      name = "team1"
      flux = {
        enabled = true
        azure_devops = {
          org  = "org"
          proj = "proj"
          repo = "repo"
        }
      }
    }
  ]
}
