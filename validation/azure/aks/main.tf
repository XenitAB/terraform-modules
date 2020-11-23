terraform {
  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.0.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "random" {}

module "aks" {
  source = "../../../modules/azure/aks"

  providers = {
    azurerm = azurerm
  }

  environment     = "dev"
  location_short  = "we"
  name            = "xks"
  core_name       = "core"
  aks_name_suffix = "1"

  aks_config = {
    kubernetes_version = "1.18.8"
    sku_tier           = "Standard"
    default_node_pool = {
      orchestrator_version = "1.18.8"
      vm_size              = "Standard_B2s"
      min_count            = 1
      max_count            = 1
      node_labels = {
        "test" = "test"
      }
    }
    additional_node_pools = [
      {
        name                 = "node-pool"
        orchestrator_version = "1.18.8"
        vm_size              = "Standard_B2s"
        min_count            = 1
        max_count            = 1
        node_taints = [
          "test"
        ]
        node_labels = {
          "test" = "test"
        }
      }
    ]
  }
  namespaces = [
    {
      name                    = "team1"
      delegate_resource_group = true
      labels = {
        "test" = "test"
      }
      flux = {
        enabled      = true
        azdo_org     = "org"
        azdo_project = "proj"
        azdo_repo    = "repo"
      }
    }
  ]
  aks_public_ip_prefix_id = "id"
  aks_authorized_ips      = ["0.0.0.0/0"]
  ssh_public_key          = "key"

  aad_pod_identity = {
    "test" = {
      id        = "id"
      client_id = "id"
    }
  }
  aad_groups = {
    view = {
      test = {
        id   = "id"
        name = "name"
      }
    }
    edit = {
      test = {
        id   = "id"
        name = "name"
      }
    }
    cluster_admin = {
      id   = "id"
      name = "name"
    }
    cluster_view = {
      id   = "id"
      name = "name"
    }
    aks_managed_identity = {
      id   = "id"
      name = "name"
    }
  }

  azure_devops_organization = "xenitab"
  external_dns_identity = {
    client_id   = "id"
    resource_id = "id"
  }
  velero_enabled = true
  velero = {
    azure_storage_account_name      = "name"
    azure_storage_account_container = "container"
    identity = {
      client_id   = "id"
      resource_id = "id"
    }
  }
}
