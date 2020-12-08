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

  azure_devops_pat = "foo"
  azure_devops_org = "bar"
  environment = "dev"

  namespaces = [
    {
      name = "team1"
      flux = {
        enabled      = true
        azure_devops = {
          org     = "org"
          proj = "proj"
          repo    = "repo"
        }
      }
    }
  ]
}
