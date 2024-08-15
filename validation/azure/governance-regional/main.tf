terraform {
  required_providers {
    pal = {
      source = "xenitab/pal"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "pal" {}

module "governance-regional" {
  source = "../../../modules/azure/governance-regional"

  environment                  = "dev"
  location_short               = "we"
  location                     = "West Europe"
  core_name                    = "core"
  owner_service_principal_name = "test"
  aad_sp_passwords             = { "key" = "pwd" }
  resource_group_configs = [
    {
      common_name                = "core",
      delegate_aks               = false,
      delegate_key_vault         = true,
      delegate_service_endpoint  = false,
      delegate_service_principal = false,
      lock_resource_group        = false,
      disable_unique_suffix      = false,
      tags = {
        "description" = "Core infrastructure"
      }
    },
    {
      common_name                = "hub",
      delegate_aks               = false,
      delegate_key_vault         = true,
      delegate_service_endpoint  = false,
      delegate_service_principal = false,
      lock_resource_group        = false,
      disable_unique_suffix      = false,
      tags = {
        "description" = "Hub for SPOF infra"
      }
    },
    {
      common_name                = "azpagent",
      delegate_aks               = false,
      delegate_key_vault         = true,
      delegate_service_endpoint  = false,
      delegate_service_principal = false,
      lock_resource_group        = false,
      disable_unique_suffix      = false,
      tags = {
        "description" = "Azure Pipelines Agent"
      }
    },
    {
      common_name                = "aks",
      delegate_aks               = false,
      delegate_key_vault         = true,
      delegate_service_endpoint  = false,
      delegate_service_principal = false,
      lock_resource_group        = false,
      disable_unique_suffix      = false,
      tags = {
        "description" = "Azure Kubernetes Service"
      }
    },
    {
      common_name                = "team1",
      delegate_aks               = true,
      delegate_key_vault         = true,
      delegate_service_endpoint  = true,
      delegate_service_principal = true,
      lock_resource_group        = true,
      disable_unique_suffix      = true,
      tags = {
        "description" = "team1"
      }
    },
  ]
  azuread_groups = {
    rg_owner = {
      test = {
        id = "00000000-0000-0000-0000-000000000000"
      }
    }
    rg_contributor = {
      test = {
        id = "00000000-0000-0000-0000-000000000000"
      }
    }
    rg_reader = {
      test = {
        id = "00000000-0000-0000-0000-000000000000"
      }
    }
    sub_owner = {
      id = "00000000-0000-0000-0000-000000000000"
    }
    sub_contributor = {
      id = "00000000-0000-0000-0000-000000000000"
    }
    sub_reader = {
      id = "00000000-0000-0000-0000-000000000000"
    }
    service_endpoint_join = {
      id = "00000000-0000-0000-0000-000000000000"
    }
  }
  azuread_apps = {
    delegate_kv = {
      test = {
        display_name                = "test"
        application_object_id       = "00000000-0000-0000-0000-000000000000"
        client_id                   = "00000000-0000-0000-0000-000000000000"
        service_principal_object_id = "00000000-0000-0000-0000-000000000000"
      }
    }
    rg_contributor = {
      test = {
        display_name                = "test"
        application_object_id       = "00000000-0000-0000-0000-000000000000"
        client_id                   = "00000000-0000-0000-0000-000000000000"
        service_principal_object_id = "00000000-0000-0000-0000-000000000000"
      }
    }
    sub_reader = {
      display_name                = "test"
      application_object_id       = "00000000-0000-0000-0000-000000000000"
      client_id                   = "00000000-0000-0000-0000-000000000000"
      service_principal_object_id = "00000000-0000-0000-0000-000000000000"
    }
  }
}
