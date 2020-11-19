terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
  }
}

module "fluxcd_v1" {
  source = "../../../modules/kubernetes/fluxcd-v1"

  providers = {
    helm = helm
  }

  azdo_proxy_enabled = true
  azdo_proxy_local_passwords = {
    "team1" = "password"
  }
  fluxcd_v1_git_path = "dev"

  namespaces = [
    {
      name = "team1"
      flux = {
        enabled      = true
        azdo_org     = "org"
        azdo_project = "proj"
        azdo_repo    = "repo"
      }
    }
  ]
}
