variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
}

variable "global_location_short" {
  description = "The Azure region short name where the global resources resides."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "group_name_prefix" {
  description = "Prefix for Azure AD groups"
  type        = string
}

variable "name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "aks_name_suffix" {
  description = "The suffix for the aks clusters"
  type        = number
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "priority_expander_config" {
  description = "Cluster auto scaler priority expander configuration."
  type        = map(list(string))
  default     = null
}

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

variable "kubernetes_network_policy_default_deny" {
  description = "If network policies should by default deny cross namespace traffic"
  type        = bool
  default     = true
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

variable "fluxcd_enabled" {
  description = "Should fluxcd be enabled"
  type        = bool
  default     = true
}

variable "fluxcd_config" {
  description = "Configuration for FluxCD"
  type = object({
    git_provider = object({
      organization        = string
      type                = optional(string, "azuredevops")
      include_tenant_name = optional(bool, false)
      github = optional(object({
        application_id  = number
        installation_id = number
        private_key     = string
      }))
      azure_devops = optional(object({
        pat = string
      }))
    })
    bootstrap = object({
      disable_secret_creation = optional(bool, true)
      project                 = optional(string)
      repository              = string
    })
  })
}

variable "aad_pod_identity_enabled" {
  description = "Should aad-pod-identity be enabled"
  type        = bool
  default     = true
}

variable "aad_pod_identity_config" {
  description = "Configuration for aad pod identity"
  type = map(object({
    id        = string
    client_id = string
  }))
}

variable "azure_policy_enabled" {
  description = "If the Azure Policy for Kubernetes add-on should be enabled"
  type        = bool
  default     = false
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
      "grafana-agent",
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
variable "envoy_tls_policy_enabled" {
  description = "An option to remove the gatekeeper mutation for tls settings"
  type        = bool
  default     = false
}

variable "gatekeeper_enabled" {
  description = "Should OPA Gatekeeper be enabled"
  type        = bool
  default     = true
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

variable "cert_manager_enabled" {
  description = "Should Cert Manager be enabled"
  type        = bool
  default     = true
}

variable "cert_manager_config" {
  description = "Cert Manager configuration, the first item in the list is the main domain"
  type = object({
    notification_email = string
    dns_zone           = list(string)
  })
}

variable "core_name" {
  description = "The name for the core infrastructure"
  type        = string
}

variable "ingress_nginx_enabled" {
  description = "Should Ingress NGINX be enabled"
  type        = bool
  default     = true
}

variable "ingress_nginx_config" {
  description = "Ingress configuration"
  type = object({
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

variable "external_dns_hostname" {
  description = "hostname for ingress-nginx to use for external-dns"
  type        = string
  default     = ""
}

variable "external_dns_enabled" {
  description = "Should External DNS be enabled"
  type        = bool
  default     = true
}

variable "external_dns_config" {
  description = "ExternalDNS config"
  type = object({
    extra_args = optional(list(string), [])
    sources    = optional(list(string), ["ingress", "service"])
  })
  default = {}
}

variable "mirrord_enabled" {
  description = "Should mirrord be enabled"
  type        = bool
  default     = false
}


variable "telepresence_enabled" {
  description = "Should Telepresence be enabled"
  type        = bool
  default     = false
}

variable "telepresence_config" {
  description = "Config to use when deploying traffic manager to the cluster"
  type = object({
    allow_conflicting_subnets = optional(list(string), [])
    client_rbac = object({
      create     = bool
      namespaced = bool
      namespaces = optional(list(string), ["ambassador"])
      subjects   = optional(list(string), [])
    })
    manager_rbac = object({
      create     = bool
      namespaced = bool
      namespaces = optional(list(string), [])
    })
  })
  default = {
    client_rbac : {
      create : false
      namespaced : false
    }
    manager_rbac : {
      create : true
      namespaced : true
    }
  }
}

variable "velero_enabled" {
  description = "Should Velero be enabled"
  type        = bool
  default     = false
}

variable "velero_config" {
  description = "Velero configuration"
  type = object({
    azure_storage_account_name      = string
    azure_storage_account_container = string
  })
}

variable "datadog_enabled" {
  description = "Should Datadog be enabled"
  type        = bool
  default     = false
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

variable "grafana_agent_enabled" {
  description = "Should Grafana-Agent be enabled"
  type        = bool
  default     = false
}

variable "grafana_agent_config" {
  description = "The Grafan-Agent configuration"
  sensitive   = true
  type = object({
    remote_write_urls = object({
      metrics = string
      logs    = string
      traces  = string
    })
    credentials = object({
      metrics_username = string
      metrics_password = string
      logs_username    = string
      logs_password    = string
      traces_username  = string
      traces_password  = string
    })
    extra_namespaces        = list(string)
    include_kubelet_metrics = bool
  })
  default = {
    remote_write_urls = {
      metrics = ""
      logs    = ""
      traces  = ""
    }
    credentials = {
      metrics_username = ""
      metrics_password = ""
      logs_username    = ""
      logs_password    = ""
      traces_username  = ""
      traces_password  = ""
    }
    extra_namespaces        = ["ingress-nginx"]
    include_kubelet_metrics = false
  }
}

variable "grafana_alloy_enabled" {
  description = "Should Grafana-Alloy be enabled"
  type        = bool
  default     = false
}

variable "grafana_alloy_config" {
  description = "Grafana Alloy config"
  type = object({
    azure_key_vault_name                = string
    keyvault_secret_name                = string
    cluster_name                        = string
    grafana_otelcol_auth_basic_username = string
    grafana_otelcol_exporter_endpoint   = string
  })
}

variable "grafana_k8s_monitoring_enabled" {
  description = "Should Grafana-k8s-chart be enabled/deployed"
  type        = bool
  default     = false
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
    include_namespaces_piped      = optional(string, "")
    exclude_namespaces            = optional(string, "")
  })
}

variable "falco_enabled" {
  description = "Should Falco be enabled"
  type        = bool
  default     = true
}

variable "reloader_enabled" {
  description = "Should Reloader be enabled"
  type        = bool
  default     = true
}

variable "azad_kube_proxy_enabled" {
  description = "Should azad-kube-proxy be enabled"
  type        = bool
  default     = false
}

variable "azad_kube_proxy_config" {
  description = "The azad-kube-proxy configuration"
  type = object({
    fqdn        = string
    allowed_ips = list(string)
  })
  default = {
    fqdn        = ""
    allowed_ips = []
  }
}

variable "prometheus_enabled" {
  description = "Should prometheus be enabled"
  type        = bool
  default     = true
}

variable "prometheus_volume_claim_storage_class_name" {
  description = "Configuration for prometheus volume claim storage class name"
  type        = string
  default     = "managed-csi-zrs"
}

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

variable "promtail_enabled" {
  description = "Should promtail be enabled"
  type        = bool
  default     = false
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

variable "ingress_healthz_enabled" {
  description = "Should ingress-healthz be enabled"
  type        = bool
  default     = true
}

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}

variable "trivy_enabled" {
  description = "Should trivy be enabled"
  type        = bool
  default     = true
}

variable "trivy_volume_claim_storage_class_name" {
  description = "Configuration for trivy volume claim storage class name"
  type        = string
  default     = "managed-csi-zrs"
}

variable "trivy_config" {
  description = "Configuration for trivy"
  type = object({
    starboard_exporter_enabled = optional(bool, true)
  })
}

variable "azure_metrics_enabled" {
  description = "Should AZ Metrics be enabled"
  type        = bool
  default     = true
}

variable "vpa_enabled" {
  description = "Should VPA be enabled"
  type        = bool
  default     = true
}

variable "node_local_dns_enabled" {
  description = "Should VPA be enabled"
  type        = bool
  default     = true
}

variable "node_ttl_enabled" {
  description = "Should Node TTL be enabled"
  type        = bool
  default     = true
}

variable "spegel_enabled" {
  description = "Should Spegel be enabled"
  type        = bool
  default     = true
}

variable "control_plane_logs_enabled" {
  description = "Should Control plan be enabled"
  type        = bool
  default     = false
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

variable "defender_enabled" {
  description = "If Defender for Containers should be enabled"
  type        = bool
  default     = false
}

variable "coredns_upstream" {
  type        = bool
  description = "Should coredns be used as the last route instead of upstream dns?"
  default     = false
}

variable "dns_zones" {
  description = "List of DNS Zones"
  type        = list(string)
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "use_private_ingress" {
  description = "If true, private ingress will be used by azad-kube-proxy"
  type        = bool
  default     = false
}

variable "cilium_enabled" {
  description = "If enabled, will use Azure CNI with Cilium instead of kubenet"
  type        = bool
  default     = false
}

variable "azure_service_operator_enabled" {
  description = "If Azure Service Operator should be enabled"
  type        = bool
  default     = false
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

variable "gateway_api_enabled" {
  description = "If Gateway API should be enabled"
  type        = bool
  default     = true
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

variable "nginx_gateway_enabled" {
  description = "Should NGINX Gateway Fabric be enabled"
  type        = bool
  default     = false
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

variable "karpenter_enabled" {
  description = "If Karpenter should be enabled"
  type        = bool
  default     = false
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


variable "envoy_gateway" {
  description = "Should we deploy envoy-gateway"
  type = object({
    enabled = optional(bool, false)
    config = optional(object({
      logging_level             = optional(string, "info")
      replicas_count            = optional(number, 2)
      resources_memory_limit    = optional(string, "")
      resources_cpu_requests    = optional(string, "")
      resources_memory_requests = optional(string, "")
    }))

  })
  default = {
    config = {
      logging_level             = "info"
      replica_count             = 2
      resources_cpu_requests    = ""
      resources_memory_limit    = ""
      resources_memory_requests = ""
    }
  }
}

variable "popeye_enabled" {
  description = "If the popeye module should be installed"
  type        = bool
  default     = false
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
