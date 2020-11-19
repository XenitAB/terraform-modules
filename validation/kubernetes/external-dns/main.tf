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
  azure_tenant_id       = "id"
  azure_subscription_id = "id"
  azure_resource_group  = "name"
  azure_client_id       = "id"
  azure_resource_id     = "id"
}
