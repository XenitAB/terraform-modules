terraform {
}

module "aks_core" {
  source = "../../../modules/kubernetes/aks-core"
  envoy_gateway = {
    enabled = true
    envoy_gateway_config = {
      logging_level             = "debug"
      replicas_count            = 42
      resources_memory_limit    = "30g"
      resources_cpu_requests    = "5000mi"
      resources_memory_requests = "50g"
    }

  }
  grafana_k8s_monitor_config = {
    grafana_cloud_prometheus_host = "sda"
    grafana_cloud_loki_host       = "asdw"
    grafana_cloud_tempo_host      = "asdas"
    cluster_name                  = "asdas"
    azure_key_vault_name          = "yaba"
    include_namespaces            = "one,two,three"
    include_namespaces_piped      = "one|two|three"
    exclude_namespaces            = ["threetwoone"]
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
  trivy_config = {}
  ingress_nginx_config = {
    private_ingress_enabled = false
  }
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
  nginx_healthz_ingress_whitelist_ips = ""
  platform_config = {
    tenant_name = "my-tenant-name"
    fleet_infra_config = {
      git_repo_url        = "https://some-git-repo.git"
      argocd_project_name = "default"
      k8s_api_server_url  = "https://kubernetes.default.svc"
    }
    aad_pod_identity_enabled       = true
    azure_metrics_enabled          = true
    azure_policy_enabled           = true
    azure_service_operator_enabled = true
    cilium_enabled                 = true
    control_plane_logs_enabled     = true
    datadog_enabled                = true
    eck_operator_enabled           = true
    gateway_api_enabled            = true
    grafana_agent_enabled          = true
    grafana_alloy_enabled          = true
    grafana_k8s_monitoring_enabled = true
    karpenter_enabled              = true
    linkerd_enabled                = true
    litmus_enabled                 = true
    mirrord_enabled                = true
    nginx_gateway_enabled          = true
    popeye_enabled                 = true
    prometheus_enabled             = true
    promtail_enabled               = true
    rabbitmq_enabled               = true
    spot_instances_hack_enabled    = true
    telepresence_enabled           = true
    trivy_enabled                  = true
    velero_enabled                 = true
    vpa_enabled                    = true
  }
}
