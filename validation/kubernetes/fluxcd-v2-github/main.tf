terraform {
  required_providers {
  }
}

module "fluxcd_v2" {
  source = "../../../modules/kubernetes/fluxcd-v2-github"

  github_owner = "foo"
  bootstrap_path = "dev"
  namespaces = []
}
