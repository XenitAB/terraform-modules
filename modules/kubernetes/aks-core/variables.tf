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
      flux = object({
        enabled     = bool
        create_crds = bool
        azure_devops = object({
          org  = string
          proj = string
          repo = string
        })
        github = object({
          repo = string
        })
      })
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

variable "fluxcd_v2_enabled" {
  description = "Should fluxcd-v2 be enabled"
  type        = bool
  default     = true
}

variable "fluxcd_v2_config" {
  description = "Configuration for fluxcd-v2"
  type = object({
    type = string
    github = object({
      org             = string
      app_id          = number
      installation_id = number
      private_key     = string
    })
    azure_devops = object({
      pat  = string
      org  = string
      proj = string
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

variable "opa_gatekeeper_enabled" {
  description = "Should OPA Gatekeeper be enabled"
  type        = bool
  default     = true
}

variable "opa_gatekeeper_config" {
  description = "Configuration for OPA Gatekeeper"
  type = object({
    additional_excluded_namespaces = list(string)
    enable_default_constraints     = bool
    additional_constraints = list(object({
      excluded_namespaces = list(string)
      processes           = list(string)
    }))
    enable_default_assigns = bool
    additional_assigns = list(object({
      name = string
    }))
    additional_modify_sets = list(object({
      name = string
    }))
  })
  default = {
    additional_excluded_namespaces = []
    enable_default_constraints     = true
    additional_constraints         = []
    enable_default_assigns         = true
    additional_assigns             = []
    additional_modify_sets         = []
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

variable "ingress_nginx_enabled" {
  description = "Should Ingress NGINX be enabled"
  type        = bool
  default     = true
}

variable "ingress_nginx_config" {
  description = "Ingress configuration"
  type = object({
    public_private_enabled = bool
    customization = optional(object({
      allow_snippet_annotations = bool
      http_snippet              = string
      extra_config              = map(string)
      extra_headers             = map(string)
    }))
    customization_public = optional(object({
      allow_snippet_annotations = optional(bool)
      http_snippet              = optional(string)
      extra_config              = optional(map(string))
      extra_headers             = optional(map(string))
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
  description = "External DNS configuration"
  type = object({
    client_id   = string
    resource_id = string
  })
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
    identity = object({
      client_id   = string
      resource_id = string
    })
  })
}

variable "csi_secrets_store_provider_azure_enabled" {
  description = "Should csi-secrets-store-provider-azure be enabled"
  type        = bool
  default     = true
}

variable "datadog_enabled" {
  description = "Should Datadog be enabled"
  type        = bool
  default     = false
}

variable "datadog_config" {
  description = "Datadog configuration"
  type = object({
    datadog_site         = string
    api_key              = string
    app_key              = string
    namespaces           = list(string)
    apm_ignore_resources = list(string)
    path_kustomization   = string
    path_platform        = string
  })
  default = {
    datadog_site         = ""
    api_key              = ""
    app_key              = ""
    namespaces           = [""]
    apm_ignore_resources = []
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
    azure_ad_app = object({
      client_id     = string
      client_secret = string
      tenant_id     = string
    })
  })
  default = {
    fqdn        = ""
    allowed_ips = []
    azure_ad_app = {
      client_id     = ""
      client_secret = ""
      tenant_id     = ""
    }
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
    azure_key_vault_name = string
    identity = object({
      client_id   = string
      resource_id = string
      tenant_id   = string
    })

    tenant_id = string

    remote_write_authenticated = bool
    remote_write_url           = string

    volume_claim_size = string

    resource_selector  = list(string)
    namespace_selector = list(string)
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
    identity = object({
      client_id   = string
      resource_id = string
      tenant_id   = string
    })
    loki_address        = string
    excluded_namespaces = list(string)
  })
  default = {
    azure_key_vault_name = ""
    identity = {
      client_id   = ""
      resource_id = ""
      tenant_id   = ""
    }
    loki_address        = ""
    excluded_namespaces = []
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
    client_id   = string
    resource_id = string
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

variable "azure_metrics_config" {
  description = "AZ Metrics configuration"
  type = object({
    client_id   = string
    resource_id = string
  })
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
    identity = object({
      client_id   = string
      resource_id = string
      tenant_id   = string
    })
    eventhub_hostname = string
    eventhub_name     = string
  })
  default = {
    azure_key_vault_name = ""
    identity = {
      client_id   = ""
      resource_id = ""
      tenant_id   = ""
    }
    eventhub_hostname = ""
    eventhub_name     = ""
  }
}
