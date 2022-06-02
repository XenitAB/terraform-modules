terraform {}

provider "azurerm" {
  features {}
}

module "aks_core" {
  source = "../../../modules/kubernetes/aks-core"

  name            = "baz"
  aks_name_suffix = 1
  location_short  = "foo"
  environment     = "bar"
  namespaces      = []
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
    dns_zone           = ["bar", "faa"]
  }
  fluxcd_v2_credentials = {
    type = "github"

    github = ({
      github_org             = ""
      github_app_id          = 0
      github_installation_id = 0
      github_private_key     = ""
    })
    azure_devops = ({
      azure_devops_org  = ""
      azure_devops_pat  = ""
      azure_devops_proj = ""
    })
  }

  fluxcd_v2_fleet_infra = {
    type = "github"
    org  = "Foo"
    proj = "Bar"
    repo = "Foobar"
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
  azure_metrics_config = {
    client_id   = "foo"
    resource_id = "bar"
  }

  starboard_enabled = true

  ingress_config = {
    http_snippet              = ""
    public_private_enabled    = false
    allow_snippet_annotations = false
  }

  prometheus_enabled = true
  prometheus_config = {
    azure_key_vault_name = "foobar"
    identity = {
      client_id   = ""
      resource_id = ""
      tenant_id   = ""
    }

    tenant_id = ""

    remote_write_authenticated = true
    remote_write_url           = "https://my-receiver.com"

    volume_claim_storage_class_name = "default"
    volume_claim_size               = "5Gi"

    resource_selector  = ["platform"]
    namespace_selector = ["platform"]
  }
}
