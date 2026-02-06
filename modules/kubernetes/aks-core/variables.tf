variable "aad_groups" {
  description = "Configuration for aad groups"
  type = object({
    view = map(any)
    edit = map(any)
    cluster_admin = object({
      id   = string
      name = string
    })
    cluster_view = object({
      id   = string
      name = string
    })
    aks_managed_identity = object({
      id   = string
      name = string
    })
  })
}

variable "aad_pod_identity_config" {
  description = "Configuration for aad pod identity"
  type = map(object({
    id        = string
    client_id = string
  }))
}

variable "acr_name_override" {
  description = "Override default name of ACR"
  type        = string
  default     = ""
}

variable "additional_storage_classes" {
  description = "List of additional storage classes to create"
  type = list(object({
    name           = string
    provisioner    = string
    reclaim_policy = string
    binding_mode   = string
    parameters     = map(string)
  }))
  default = []
}

variable "aks_name_suffix" {
  description = "The suffix for the aks clusters"
  type        = number
}

variable "argocd_config" {
  description = "ArgoCD configuration"
  type = object({
    aad_group_name                  = optional(string, "az-sub-xks-all-owner")
    cluster_role                    = optional(string, "Spoke")
    application_set_replicas        = optional(number, 2)
    controller_replicas             = optional(number, 3)
    repo_server_replicas            = optional(number, 2)
    server_replicas                 = optional(number, 2)
    dynamic_sharding                = optional(bool, false)
    controller_status_processors    = optional(number, 50)
    controller_operation_processors = optional(number, 100)
    argocd_k8s_client_qps           = optional(number, 150)
    argocd_k8s_client_burst         = optional(number, 300)
    redis_enabled                   = optional(bool, true)
    global_domain                   = optional(string, "")
    ingress_whitelist_ip            = optional(string, "")
    dex_tenant_name                 = optional(string, "")
    dex_redirect_domains            = optional(string, "")
    oidc_issuer_url                 = optional(map(string), {})
    sync_windows = optional(list(object({
      kind        = string
      schedule    = string
      duration    = string
      manual_sync = optional(bool, true)
    })), [])
    azure_tenants = optional(list(object({
      tenant_name = string
      tenant_id   = string
      clusters = list(object({
        name            = string
        api_server      = string
        environment     = string
        azure_client_id = optional(string, "")
        ca_data         = optional(string, "")
        tenants = list(object({
          # This will be used to only if cluster_role is set to 'Hub-Spoke' to create AppProject 
          # roles that limit access to the project, based on the AAD group we create for each 
          # tenant namespace.
          aad_group              = optional(string, "")
          name                   = string
          namespace              = string
          repo_url               = string
          repo_path              = string
          github_app_id          = string
          github_installation_id = string
          secret_name            = string
        }))
      }))
    })), [])
  })
  default = {}

  validation {
    condition     = contains(["Hub", "Spoke", "Hub-Spoke"], var.argocd_config.cluster_role)
    error_message = "Invalid cluster role: ${var.argocd_config.cluster_role}. Allowed vallues: ['Hub', 'Spoke', 'Hub-Spoke']"
  }
}

variable "azure_policy_config" {
  description = "A list of Azure policy mutations to create and include in the XKS policy set definition"
  type = object({
    exclude_namespaces = list(string)
    mutations = list(object({
      name         = string
      display_name = string
      template     = string
    }))
  })
  default = {
    exclude_namespaces = [
      "linkerd",
      "linkerd-cni",
      "velero",
      "grafana-alloy",
    ]
    mutations = [
      {
        name         = "ContainerNoPrivilegeEscalation"
        display_name = "Containers should not use privilege escalation"
        template     = "container-disallow-privilege-escalation.yaml.tpl"
      },
      {
        name         = "ContainerDropCapabilities"
        display_name = "Containers should drop disallowed capabilities"
        template     = "container-drop-capabilities.yaml.tpl"
      },
      {
        name         = "ContainerReadOnlyRootFs"
        display_name = "Containers should use a read-only root filesystem"
        template     = "container-read-only-root-fs.yaml.tpl"
      },
      {
        name         = "EphemeralContainerNoPrivilegeEscalation"
        display_name = "Ephemeral containers should not use privilege escalation"
        template     = "ephemeral-container-disallow-privilege-escalation.yaml.tpl"
      },
      {
        name         = "EphemeralContainerDropCapabilities"
        display_name = "Ephemeral containers should drop disallowed capabilities"
        template     = "ephemeral-container-drop-capabilities.yaml.tpl"
      },
      {
        name         = "EphemeralContainerReadOnlyRootFs"
        display_name = "Ephemeral containers should use a read-only root filesystem"
        template     = "ephemeral-container-read-only-root-fs.yaml.tpl"
      },
      {
        name         = "InitContainerNoPrivilegeEscalation"
        display_name = "Init containers should not use privilege escalation"
        template     = "init-container-disallow-privilege-escalation.yaml.tpl"
      },
      {
        name         = "InitContainerDropCapabilities"
        display_name = "Init containers should drop disallowed capabilities"
        template     = "init-container-drop-capabilities.yaml.tpl"
      },
      {
        name         = "InitContainerReadOnlyRootFs"
        display_name = "Init containers should use a read-only root filesystem"
        template     = "init-container-read-only-root-fs.yaml.tpl"
      },
      {
        name         = "PodDefaultSecComp"
        display_name = "Pods should use an allowed seccomp profile"
        template     = "k8s-pod-default-seccomp.yaml.tpl"
      },
      {
        name         = "PodServiceAccountTokenNoAutoMount"
        display_name = "Pods should not automount service account tokens"
        template     = "k8s-pod-serviceaccount-token-false.yaml.tpl"
      },
    ]
  }
}

variable "azure_service_operator_config" {
  description = "Azure Service Operator configuration"
  type = object({
    cluster_config = optional(object({
      sync_period    = optional(string, "1m")
      enable_metrics = optional(bool, false)
      crd_pattern    = optional(string, "") # never set this to '*', limit this to the resources that are actually needed
    }), {})
    tenant_namespaces = optional(list(object({
      name = string
    })), [])
  })
  default = {}

  validation {
    condition     = var.azure_service_operator_config.cluster_config.crd_pattern != "*"
    error_message = "Installing all CRD:s in the cluster is not supported, please limit to the ones needed"
  }
}

variable "cert_manager_config" {
  description = "Cert Manager configuration, the first item in the list is the main domain"
  type = object({
    notification_email = string
    dns_zone           = list(string)
    rbac_create        = optional(bool, true)
  })
}

variable "control_plane_logs_config" {
  description = "Configuration for control plane log"
  type = object({
    azure_key_vault_name = string
    eventhub_hostname    = string
    eventhub_name        = string
  })
  default = {
    azure_key_vault_name = ""
    eventhub_hostname    = ""
    eventhub_name        = ""
  }
}

variable "core_name" {
  description = "The name for the core infrastructure"
  type        = string
}

variable "datadog_config" {
  description = "Datadog configuration"
  type = object({
    azure_key_vault_name = string
    datadog_site         = string
    namespaces           = list(string)
    apm_ignore_resources = list(string)
  })
  default = {
    azure_key_vault_name = ""
    datadog_site         = ""
    namespaces           = [""]
    apm_ignore_resources = [""]
  }
}

variable "dns_zones" {
  description = "List of DNS Zones"
  type        = list(string)
}

variable "eck_operator_config" {
  description = "Configuration for ECK operator"
  type = object({
    eck_managed_namespaces = optional(list(string))
  })
  default = {
    eck_managed_namespaces = []
  }
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}


variable "external_dns_config" {
  description = "ExternalDNS config"
  type = object({
    extra_args  = optional(list(string), [])
    rbac_create = optional(bool, true),
    sources     = optional(list(string), ["ingress", "service", "gateway-httproute"])
    tenant_id   = optional(string, "")
  })
  default = {}
}

variable "external_dns_hostname" {
  description = "hostname for ingress-nginx to use for external-dns"
  type        = string
  default     = ""
}

variable "envoy_gateway_config" {
  description = "Configuration for Envoy Gateway"
  type = object({
    logging_level             = optional(string, "info")
    replicas_count            = optional(number, 2)
    resources_memory_limit    = optional(string, "1Gi")
    resources_cpu_limit       = optional(string, "1000m")
    resources_cpu_requests    = optional(string, "100m")
    resources_memory_requests = optional(string, "256Mi")
    proxy_cpu_limit           = optional(string, "2000m")
    proxy_memory_limit        = optional(string, "2Gi")
    proxy_cpu_requests        = optional(string, "200m")
    proxy_memory_requests     = optional(string, "512Mi")
    healthz_whitelist_ips     = optional(list(string), [""])
  })
  default = {}
}

variable "external_secrets_config" {
  description = "External secrets operator config"
  type = object({
    log_level               = optional(string, "info")
    metrics_enabled         = optional(bool, false)
    pdb_enabled             = optional(bool, true)
    replica_count           = optional(number, 2)
    service_monitor_enabled = optional(bool, true)
  })
  default = {}
}

variable "fluxcd_config" {
  description = "Configuration for FluxCD"
  type = object({
    git_provider = object({
      organization = string
      type         = optional(string, "azuredevops")
      github = optional(object({
        application_id  = optional(string, "")
        installation_id = optional(string, "")
        private_key     = optional(string, "")
        }), {
        application_id  = "",
        installation_id = "",
        private_key     = ""
      })
    })
  })
}

variable "gatekeeper_config" {
  description = "Configuration for OPA Gatekeeper"
  type = object({
    exclude_namespaces = list(string)
  })
  default = {
    exclude_namespaces = []
  }
}

variable "gateway_api_config" {
  description = "The Gateway API configuration"
  type = object({
    api_version       = optional(string, "v1.2.0")
    api_channel       = optional(string, "standard")
    gateway_name      = optional(string, "")
    gateway_namespace = optional(string, "")
  })
  default = {}

  validation {
    condition     = contains(["standard", "experimental"], var.gateway_api_config.api_channel)
    error_message = "Invalid API channel: ${var.gateway_api_config.api_channel}. Allowed vallues: ['standard', 'experimental']"
  }
}

variable "global_location_short" {
  description = "The Azure region short name where the global resources resides."
  type        = string
}

variable "grafana_alloy_config" {
  description = "Grafana Alloy configuration"
  type = object({
    azure_key_vault_name = string
    keyvault_secret_name = string
    remote_write_urls = object({
      metrics = string
      logs    = string
      traces  = string
    })
    extra_namespaces        = list(string)
    include_kubelet_metrics = bool
  })
  default = {
    azure_key_vault_name = ""
    keyvault_secret_name = ""
    remote_write_urls = {
      metrics = ""
      logs    = ""
      traces  = ""
    }
    extra_namespaces        = ["ingress-nginx"]
    include_kubelet_metrics = false
  }
}

variable "grafana_k8s_monitor_config" {
  description = "Grafana k8s monitor chart config"
  type = object({
    azure_key_vault_name          = string
    grafana_cloud_prometheus_host = optional(string, "")
    grafana_cloud_loki_host       = optional(string, "")
    grafana_cloud_tempo_host      = optional(string, "")
    cluster_name                  = string
    include_namespaces            = optional(string, "")
    exclude_namespaces            = optional(list(string), [])
    node_exporter_node_affinity   = optional(map(string), {})
  })
  default = {
    azure_key_vault_name          = ""
    grafana_cloud_prometheus_host = ""
    grafana_cloud_loki_host       = ""
    grafana_cloud_tempo_host      = ""
    cluster_name                  = ""
    include_namespaces            = ""
    exclude_namespaces            = []
    node_exporter_node_affinity   = {}
  }
}

variable "keyvault_name_override" {
  description = "Override for keyvault name"
  type        = string
  default     = ""
}
variable "group_name_prefix" {
  description = "Prefix for Azure AD groups"
  type        = string
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "ingress_nginx_config" {
  description = "Ingress configuration"
  type = object({
    replicas                = optional(number, 3)
    min_replicas            = optional(number, 2)
    private_ingress_enabled = bool
    customization = optional(object({
      allow_snippet_annotations = bool
      http_snippet              = string
      extra_config              = map(string)
      extra_headers             = map(string)
    }))
    customization_private = optional(object({
      allow_snippet_annotations = optional(bool)
      http_snippet              = optional(string)
      extra_config              = optional(map(string))
      extra_headers             = optional(map(string))
    }))
  })
}

variable "karpenter_config" {
  description = "Karpenter configuration for the AKS cluster"
  type = object({
    node_ttl      = optional(string, "168h")
    replica_count = optional(number, 2)
    node_classes = optional(list(object({
      name         = optional(string, "default")
      image_family = optional(string, "Ubuntu2204")
      kubelet = optional(object({
        container_log_max_size  = optional(string, "10Mi")
        cpu_cfs_quota           = optional(bool, true)
        cpu_cfs_quota_period    = optional(string, "100ms")
        cpu_manager_policy      = optional(string, "none")
        topology_manager_policy = optional(string, "none")
      }), {})
    })), [{}])
    node_pools = optional(list(object({
      name              = string
      consolidate_after = optional(string, "5s")
      description       = string
      disruption_budgets = optional(list(object({
        duration = optional(string, null)
        nodes    = optional(string, "10%")
        reasons  = optional(list(string), ["Drifted", "Empty", "Underutilized"])
        schedule = optional(string, null)
      })), [])
      limits = object({
        cpu    = string
        memory = string
      })
      node_annotations = optional(map(string), {})
      node_class_ref   = optional(string, "default")
      node_labels      = optional(map(string), {})
      node_requirements = optional(list(object({
        key      = string
        operator = string
        values   = list(string)
      })), [])
      node_taints = optional(list(object({
        key    = string
        effect = string
        value  = string
      })), [])
      node_ttl = optional(string, "168h")
      weight   = optional(number, 1)
    })), [])
    settings = optional(object({
      batch_idle_duration = optional(string, "1s")
      batch_max_duration  = optional(string, "10s")
    }), {})
  })
  default = {
    bootstrap_token  = ""
    cluster_endpoint = ""
    node_identities  = ""
    ssh_public_key   = ""
    vnet_subnet_id   = ""
  }

  validation {
    condition = alltrue([
      for nc in var.karpenter_config.node_classes : contains(["Ubuntu2204", "AzureLinux"], nc.image_family)
    ])
    error_message = "The AKSNodeClass imageFamily must be either 'Ubuntu2204' or 'AzureLinux'."
  }
}

variable "kubernetes_default_limit_range" {
  description = "Default limit range for tenant namespaces"
  type = object({
    default_request = object({
      cpu    = string
      memory = string
    })
    default = object({
      memory = string
    })
  })
  default = {
    default_request = {
      cpu    = "50m"
      memory = "32Mi"
    }
    default = {
      memory = "256Mi"
    }
  }
}

variable "kubernetes_network_policy_default_deny" {
  description = "If network policies should by default deny cross namespace traffic"
  type        = bool
  default     = true
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes."
  type = list(
    object({
      name   = string
      labels = map(string)
      flux = optional(object({
        provider            = string
        project             = optional(string)
        repository          = string
        include_tenant_name = optional(bool, false)
        create_crds         = optional(bool, false)
      }))
    })
  )
}

variable "nginx_gateway_config" {
  description = "Gateway Fabric configuration"
  type = object({
    logging_level     = optional(string, "info")
    replica_count     = optional(number, 2)
    telemetry_enabled = optional(bool, true)
    telemetry_config = optional(object({
      endpoint    = optional(string, "")
      interval    = optional(string, "")
      batch_size  = optional(number, 0)
      batch_count = optional(number, 0)
    }), {})
  })
  default = {}
}

variable "nginx_healthz_ingress_whitelist_ips" {
  description = "A comma separated string of ranges and or individual ips to be whitelisted for the healthz ingress"
  type        = string
  default     = ""
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "platform_config" {
  description = "Options for configuring the platform components"
  type = object({
    tenant_name = string
    fleet_infra_config = object({
      git_repo_url        = string
      argocd_project_name = string
      k8s_api_server_url  = string
    })
    aad_pod_identity_enabled          = optional(bool, false)
    argocd_enabled                    = optional(bool, true)
    azure_metrics_enabled             = optional(bool, false)
    azure_policy_enabled              = optional(bool, false)
    azure_service_operator_enabled    = optional(bool, false)
    cert_manager_enabled              = optional(bool, true)
    cilium_enabled                    = optional(bool, false)
    control_plane_logs_enabled        = optional(bool, false)
    datadog_enabled                   = optional(bool, false)
    defender_enabled                  = optional(bool, false)
    eck_operator_enabled              = optional(bool, false)
    envoy_gateway_enabled             = optional(bool, true)
    external_dns_enabled              = optional(bool, true)
    external_secrets_operator_enabled = optional(bool, false)
    falco_enabled                     = optional(bool, true)
    fluxcd_enabled                    = optional(bool, true)
    gatekeeper_enabled                = optional(bool, true)
    gateway_api_enabled               = optional(bool, false)
    grafana_alloy_enabled             = optional(bool, false)
    grafana_k8s_monitoring_enabled    = optional(bool, false)
    ingress_nginx_enabled             = optional(bool, true)
    karpenter_enabled                 = optional(bool, false)
    linkerd_enabled                   = optional(bool, false)
    litmus_enabled                    = optional(bool, false)
    mirrord_enabled                   = optional(bool, false)
    nginx_gateway_enabled             = optional(bool, false)
    node_local_dns_enabled            = optional(bool, true)
    node_ttl_enabled                  = optional(bool, true)
    popeye_enabled                    = optional(bool, false)
    prometheus_enabled                = optional(bool, false)
    promtail_enabled                  = optional(bool, false)
    rabbitmq_enabled                  = optional(bool, false)
    reloader_enabled                  = optional(bool, true)
    spegel_enabled                    = optional(bool, true)
    spot_instances_hack_enabled       = optional(bool, false)
    trivy_enabled                     = optional(bool, false)
    velero_enabled                    = optional(bool, false)
    vpa_enabled                       = optional(bool, false)
  })
}

variable "popeye_config" {
  description = "The popeye configuration"
  type = object({
    allowed_registries = optional(list(string), [])
    cron_jobs = optional(list(object({
      namespace     = optional(string, "default")
      resources     = optional(string, "cj,cm,deploy,ds,gw,gwc,gwr,hpa,ing,job,np,pdb,po,pv,pvc,ro,rb,sa,sec,sts,svc")
      output_format = optional(string, "html")
      schedule      = optional(string, "0 0 * * 1")
    })), [{}])
    storage_account = optional(object({
      resource_group_name = optional(string, "")
      account_name        = optional(string, "")
      file_share_size     = optional(string, "1Gi")
    }), {})
  })
  default = {}
}

variable "priority_expander_config" {
  description = "Cluster auto scaler priority expander configuration."
  type        = map(list(string))
  default     = null
}
/*
variable "prometheus_config" {
  description = "Configuration for prometheus"
  type = object({
    azure_key_vault_name       = string
    tenant_id                  = string
    remote_write_authenticated = bool
    remote_write_url           = string
    volume_claim_size          = string
    resource_selector          = list(string)
    namespace_selector         = list(string)
  })
}

variable "prometheus_volume_claim_storage_class_name" {
  description = "Configuration for prometheus volume claim storage class name"
  type        = string
  default     = "managed-csi-zrs"
}

variable "promtail_config" {
  description = "Configuration for promtail"
  type = object({
    azure_key_vault_name = string
    loki_address         = string
    excluded_namespaces  = list(string)
  })
  default = {
    azure_key_vault_name = ""
    loki_address         = ""
    excluded_namespaces  = []
  }
}
*/
variable "rabbitmq_config" {
  description = "The RabbitMQ operator configuration"
  type = object({
    min_available           = optional(number, 0)
    replica_count           = optional(number, 1)
    network_policy_enabled  = optional(bool, false)
    spot_instances_enabled  = optional(bool, true)
    tology_operator_enabled = optional(bool, false)
    watch_namespaces        = optional(list(string), [])
    target_revision         = optional(string, "main")
  })
  default = {}
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
}

variable "trivy_config" {
  description = "Configuration for trivy"
  type = object({
    starboard_exporter_enabled = optional(bool, true)
  })
}


variable "trivy_volume_claim_storage_class_name" {
  description = "Configuration for trivy volume claim storage class name"
  type        = string
  default     = "managed-csi-zrs"
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "velero_config" {
  description = "Velero configuration"
  type = object({
    azure_storage_account_name      = string
    azure_storage_account_container = string
  })
}
