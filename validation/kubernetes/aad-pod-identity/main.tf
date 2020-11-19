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

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"

  providers = {
    helm = helm
  }

  aad_pod_identity = {
    "test" = {
      id        = "id"
      client_id = "id"
    }
  }

  namespaces = [
    {
      name = "team1"
    }
  ]
}
