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
    dns_zone           = "bar"
  }
  fluxcd_v2_config = {
    type = "github"
    github = {
      org             = ""
      app_id          = 0
      installation_id = 0
      private_key     = ""
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

  ingress_config = {
    http_snippet           = ""
    public_private_enabled = false
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
  kube_state_metrics_namepsaces_extras = ["foo"]
}
