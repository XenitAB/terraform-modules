terraform {
}

module "aks_core" {
  source = "../../../modules/kubernetes/aks-core"

  grafana_k8s_monitor_config = {
    grafana_cloud_prometheus_host = "sda"
    grafana_cloud_loki_host       = "asdw"
    grafana_cloud_tempo_host      = "asdas"
    cluster_name                  = "asdas"
    azure_key_vault_name          = "yaba"
    include_namespaces            = "one,two,three"
    include_namespaces_piped      = "one|two|three"
    exclude_namespaces            = "three,two,one"
  }
  grafana_alloy_config = {
    cluster_name                        = "awesome_cluster"
    azure_key_vault_name                = "foobar"
    keyvault_secret_name                = "barfoo"
    grafana_otelcol_auth_basic_username = "some-integers"
    grafana_otelcol_exporter_endpoint   = "some-url"
  }
  name                    = "baz"
  aks_name_suffix         = 1
  core_name               = "core"
  dns_zones               = ["a.com"]
  oidc_issuer_url         = "url"
  location_short          = "foo"
  global_location_short   = "sc"
  environment             = "bar"
  subscription_name       = "baz"
  group_name_prefix       = "aks"
  namespaces              = []
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
  fluxcd_config = {
    git_provider = {
      organization        = "my-org"
      type                = "azuredevops"
      include_tenant_name = true
      azure_devops = {
        pat = "my-pat"
      }
    }
    bootstrap = {
      disable_secret_creation = true
      project                 = "my-proj"
      repository              = "my-repo"
    }
  }
  priority_expander_config = { "10" : [".*standard.*"], "20" : [".*spot.*"] }
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
  trivy_enabled = true
  trivy_config  = {}
  ingress_nginx_config = {
    private_ingress_enabled = false
  }
  prometheus_enabled = true
  prometheus_config = {
    azure_key_vault_name            = "foobar"
    tenant_id                       = ""
    remote_write_authenticated      = true
    remote_write_url                = "https://my-receiver.com"
    volume_claim_storage_class_name = "default"
    volume_claim_size               = "5Gi"
    resource_selector               = ["platform"]
    namespace_selector              = ["platform"]
  }
  external_dns_hostname = "foobar.com"
  contour_enabled = true
}
