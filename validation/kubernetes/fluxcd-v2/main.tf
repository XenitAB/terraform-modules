terraform {
  required_providers {
  }
}

module "fluxcd_v2" {
  source = "../../../modules/kubernetes/fluxcd-v2"

  azdo_pat = "123456"
  azdo_org = "foo"
  azdo_proj = "bar"
  repository_name = "baz"
  git_path = "dev"
  namespaces = []
}
