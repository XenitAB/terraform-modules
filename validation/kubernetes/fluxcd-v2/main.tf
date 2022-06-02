terraform {}

module "fluxcd_v2" {
  source = "../../../modules/kubernetes/fluxcd-v2"

  azure_devops_pat       = "123456"
  azure_devops_org       = "foo"
  azure_devops_proj      = "bar"
  github_org             = "foo"
  github_app_id          = 123
  github_installation_id = 123
  github_private_key     = "foo" #tfsec:ignore:general-secrets-no-plaintext-exposure
  environment            = "dev"
  cluster_id             = "foobar"
  namespaces             = []
<<<<<<< HEAD
  credentials = [{
    azure_devops = {
      org = "value"
      pat = "value"
    }
    github = {
      app_id          = 1
      installation_id = 1
      org             = "value"
      private_key     = "value"
    }
    type = "github"
  }]
  fleet_infra = {
    type = "github"
    org  = "org"
    proj = "proj"
    repo = "repo"
  }
=======
>>>>>>> cab92489584e7be1daf1b04ec0d09a5fabf676d1
}
