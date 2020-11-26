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

module "external_dns" {
  source = "../../../modules/kubernetes/external-dns"

  providers = {
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
