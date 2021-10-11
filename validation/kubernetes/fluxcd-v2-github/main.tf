terraform {}

module "fluxcd_v2" {
  source = "../../../modules/kubernetes/fluxcd-v2-github"

  github_org             = "foo"
  github_app_id          = 123
  github_installation_id = 123
  github_private_key     = "foo" #tfsec:ignore:GEN003
  environment            = "dev"
  cluster_id             = "foobar"
  namespaces             = []
}
