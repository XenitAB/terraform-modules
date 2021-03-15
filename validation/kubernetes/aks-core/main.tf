terraform {}

provider "azurerm" {
  features {}
}

module "aks_core" {
  source = "../../../modules/kubernetes/aks-core"

  name           = "baz"
  location_short = "foo"
  environment    = "bar"
  namespaces     = []
  external_dns_config = {
    client_id   = "foo"
    resource_id = "bar"
  }
  aad_pod_identity_config = {}
  velero_config = {
    azure_storage_account_name      = "foo"
    azure_storage_account_container = "bar"
    identity = {
      client_id   = ""
      resource_id = ""
    }
  }
  cert_manager_config = {
    notification_email = "foo"
    dns_zone           = "bar"
  }
  fluxcd_v2_config = {
    type = "github"
    github = {
      owner = ""
    }
    azure_devops = {
      pat  = ""
      org  = ""
      proj = ""
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
}
