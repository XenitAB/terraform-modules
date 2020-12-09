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

module "external_dns" {
  source = "../../../modules/kubernetes/external-dns"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  dns_provider          = "azure"
  azure_config = {
    tenant_id       = "id"
    subscription_id = "id"
    resource_group  = "name"
    client_id       = "id"
    resource_id     = "id"
  }
}
