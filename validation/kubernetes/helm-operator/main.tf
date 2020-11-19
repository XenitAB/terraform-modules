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

module "helm_operator" {
  source = "../../../modules/kubernetes/helm-operator"

  providers = {
    helm = helm
  }

  helm_operator_credentials = {
    client_id = "id"
    secret    = "secret"
  }
  acr_name           = "name"
  azdo_proxy_enabled = true
  azdo_proxy_local_passwords = {
    "team1" = "password"
  }

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
