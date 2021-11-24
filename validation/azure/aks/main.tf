terraform {}

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

  environment                   = "dev"
  location_short                = "we"
  name                          = "xks"
  core_name                     = "core"
  aks_name_suffix               = "1"
  aks_managed_identity_group_id = "1337"

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
        enabled = true
        repo    = "repo"
      }
    }
  ]
  aks_public_ip_prefix_id = "id"
  aks_authorized_ips      = ["0.0.0.0/0"]
  ssh_public_key          = "key"

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
}
