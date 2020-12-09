terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

provider "kubernetes" {
  load_config_file = "false"
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
  }
}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"

  providers = {
    kubernetes = kubernetes
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
