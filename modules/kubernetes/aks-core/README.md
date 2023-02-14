# AKS Core

This module is used to create AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.28.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.38.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.17.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.21.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.6.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.13.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.38.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.6.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.13.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aad_pod_identity"></a> [aad\_pod\_identity](#module\_aad\_pod\_identity) | ../../kubernetes/aad-pod-identity | n/a |
| <a name="module_aad_pod_identity_crd"></a> [aad\_pod\_identity\_crd](#module\_aad\_pod\_identity\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../kubernetes/azad-kube-proxy | n/a |
| <a name="module_azure_metrics"></a> [azure\_metrics](#module\_azure\_metrics) | ../../kubernetes/azure-metrics | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../../kubernetes/cert-manager | n/a |
| <a name="module_cert_manager_crd"></a> [cert\_manager\_crd](#module\_cert\_manager\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_control_plane_logs"></a> [control\_plane\_logs](#module\_control\_plane\_logs) | ../../kubernetes/control-plane-logs | n/a |
| <a name="module_csi_secrets_store_provider_azure"></a> [csi\_secrets\_store\_provider\_azure](#module\_csi\_secrets\_store\_provider\_azure) | ../../kubernetes/csi-secrets-store-provider-azure | n/a |
| <a name="module_csi_secrets_store_provider_azure_crd"></a> [csi\_secrets\_store\_provider\_azure\_crd](#module\_csi\_secrets\_store\_provider\_azure\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_datadog"></a> [datadog](#module\_datadog) | ../../kubernetes/datadog | n/a |
| <a name="module_datadog_crd"></a> [datadog\_crd](#module\_datadog\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../kubernetes/external-dns | n/a |
| <a name="module_falco"></a> [falco](#module\_falco) | ../../kubernetes/falco | n/a |
| <a name="module_fluxcd_v2_azure_devops"></a> [fluxcd\_v2\_azure\_devops](#module\_fluxcd\_v2\_azure\_devops) | ../../kubernetes/fluxcd-v2-azdo | n/a |
| <a name="module_fluxcd_v2_github"></a> [fluxcd\_v2\_github](#module\_fluxcd\_v2\_github) | ../../kubernetes/fluxcd-v2-github | n/a |
| <a name="module_grafana_agent"></a> [grafana\_agent](#module\_grafana\_agent) | ../../kubernetes/grafana-agent | n/a |
| <a name="module_grafana_agent_crd"></a> [grafana\_agent\_crd](#module\_grafana\_agent\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_ingress_healthz"></a> [ingress\_healthz](#module\_ingress\_healthz) | ../../kubernetes/ingress-healthz | n/a |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | ../../kubernetes/ingress-nginx | n/a |
| <a name="module_linkerd"></a> [linkerd](#module\_linkerd) | ../../kubernetes/linkerd | n/a |
| <a name="module_linkerd_crd"></a> [linkerd\_crd](#module\_linkerd\_crd) | ../../kubernetes/helm-crd-oci | n/a |
| <a name="module_node_local_dns"></a> [node\_local\_dns](#module\_node\_local\_dns) | ../../kubernetes/node-local-dns | n/a |
| <a name="module_node_ttl"></a> [node\_ttl](#module\_node\_ttl) | ../../kubernetes/node-ttl | n/a |
| <a name="module_opa_gatekeeper"></a> [opa\_gatekeeper](#module\_opa\_gatekeeper) | ../../kubernetes/opa-gatekeeper | n/a |
| <a name="module_opa_gatekeeper_crd"></a> [opa\_gatekeeper\_crd](#module\_opa\_gatekeeper\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ../../kubernetes/prometheus | n/a |
| <a name="module_prometheus_crd"></a> [prometheus\_crd](#module\_prometheus\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_promtail"></a> [promtail](#module\_promtail) | ../../kubernetes/promtail | n/a |
| <a name="module_reloader"></a> [reloader](#module\_reloader) | ../../kubernetes/reloader | n/a |
| <a name="module_spegel"></a> [spegel](#module\_spegel) | ../../kubernetes/spegel | n/a |
| <a name="module_trivy"></a> [trivy](#module\_trivy) | ../../kubernetes/trivy | n/a |
| <a name="module_trivy_crd"></a> [trivy\_crd](#module\_trivy\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ../../kubernetes/velero | n/a |
| <a name="module_vpa"></a> [vpa](#module\_vpa) | ../../kubernetes/vpa | n/a |
| <a name="module_vpa_crd"></a> [vpa\_crd](#module\_vpa\_crd) | ../../kubernetes/helm-crd | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.aks_core_extras](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [kubectl_manifest.priority_expander](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_cluster_role.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.get_nodes](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.get_vpa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.list_namespaces](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.top](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.trivy_reports](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.cluster_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.cluster_view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.get_nodes](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_limit_range.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/limit_range) | resource |
| [kubernetes_namespace.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/namespace) | resource |
| [kubernetes_network_policy.allow_egress_ingress_datadog](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.allow_egress_ingress_grafana_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/network_policy) | resource |
| [kubernetes_role_binding.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.top](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.trivy_reports](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.vpa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/role_binding) | resource |
| [kubernetes_storage_class.zrs_premium](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.zrs_standard](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/storage_class) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.global](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for aad groups | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>    aks_managed_identity = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_aad_pod_identity_config"></a> [aad\_pod\_identity\_config](#input\_aad\_pod\_identity\_config) | Configuration for aad pod identity | <pre>map(object({<br>    id        = string<br>    client_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_aad_pod_identity_enabled"></a> [aad\_pod\_identity\_enabled](#input\_aad\_pod\_identity\_enabled) | Should aad-pod-identity be enabled | `bool` | `true` | no |
| <a name="input_aks_name_suffix"></a> [aks\_name\_suffix](#input\_aks\_name\_suffix) | The suffix for the aks clusters | `number` | n/a | yes |
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | The azad-kube-proxy configuration | <pre>object({<br>    fqdn        = string<br>    allowed_ips = list(string)<br>    azure_ad_app = object({<br>      client_id     = string<br>      client_secret = string<br>      tenant_id     = string<br>    })<br>  })</pre> | <pre>{<br>  "allowed_ips": [],<br>  "azure_ad_app": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "tenant_id": ""<br>  },<br>  "fqdn": ""<br>}</pre> | no |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_azure_metrics_config"></a> [azure\_metrics\_config](#input\_azure\_metrics\_config) | AZ Metrics configuration | <pre>object({<br>    client_id   = string<br>    resource_id = string<br>  })</pre> | n/a | yes |
| <a name="input_azure_metrics_enabled"></a> [azure\_metrics\_enabled](#input\_azure\_metrics\_enabled) | Should AZ Metrics be enabled | `bool` | `true` | no |
| <a name="input_cert_manager_config"></a> [cert\_manager\_config](#input\_cert\_manager\_config) | Cert Manager configuration, the first item in the list is the main domain | <pre>object({<br>    notification_email = string<br>    dns_zone           = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Should Cert Manager be enabled | `bool` | `true` | no |
| <a name="input_control_plane_logs_config"></a> [control\_plane\_logs\_config](#input\_control\_plane\_logs\_config) | Configuration for control plane log | <pre>object({<br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br>    eventhub_hostname = string<br>    eventhub_name     = string<br>  })</pre> | <pre>{<br>  "azure_key_vault_name": "",<br>  "eventhub_hostname": "",<br>  "eventhub_name": "",<br>  "identity": {<br>    "client_id": "",<br>    "resource_id": "",<br>    "tenant_id": ""<br>  }<br>}</pre> | no |
| <a name="input_control_plane_logs_enabled"></a> [control\_plane\_logs\_enabled](#input\_control\_plane\_logs\_enabled) | Should Control plan be enabled | `bool` | `false` | no |
| <a name="input_csi_secrets_store_provider_azure_enabled"></a> [csi\_secrets\_store\_provider\_azure\_enabled](#input\_csi\_secrets\_store\_provider\_azure\_enabled) | Should csi-secrets-store-provider-azure be enabled | `bool` | `true` | no |
| <a name="input_datadog_config"></a> [datadog\_config](#input\_datadog\_config) | Datadog configuration | <pre>object({<br>    datadog_site         = string<br>    api_key              = string<br>    app_key              = string<br>    namespaces           = list(string)<br>    apm_ignore_resources = list(string)<br>  })</pre> | <pre>{<br>  "api_key": "",<br>  "apm_ignore_resources": [],<br>  "app_key": "",<br>  "datadog_site": "",<br>  "namespaces": [<br>    ""<br>  ]<br>}</pre> | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Should Datadog be enabled | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_external_dns_config"></a> [external\_dns\_config](#input\_external\_dns\_config) | External DNS configuration | <pre>object({<br>    client_id   = string<br>    resource_id = string<br>  })</pre> | n/a | yes |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Should External DNS be enabled | `bool` | `true` | no |
| <a name="input_external_dns_hostname"></a> [external\_dns\_hostname](#input\_external\_dns\_hostname) | hostname for ingress-nginx to use for external-dns | `string` | `""` | no |
| <a name="input_falco_enabled"></a> [falco\_enabled](#input\_falco\_enabled) | Should Falco be enabled | `bool` | `true` | no |
| <a name="input_fluxcd_v2_config"></a> [fluxcd\_v2\_config](#input\_fluxcd\_v2\_config) | Configuration for fluxcd-v2 | <pre>object({<br>    type = string<br>    github = object({<br>      org             = string<br>      app_id          = number<br>      installation_id = number<br>      private_key     = string<br>    })<br>    azure_devops = object({<br>      pat  = string<br>      org  = string<br>      proj = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_fluxcd_v2_enabled"></a> [fluxcd\_v2\_enabled](#input\_fluxcd\_v2\_enabled) | Should fluxcd-v2 be enabled | `bool` | `true` | no |
| <a name="input_global_location_short"></a> [global\_location\_short](#input\_global\_location\_short) | The Azure region short name where the global resources resides. | `string` | n/a | yes |
| <a name="input_grafana_agent_config"></a> [grafana\_agent\_config](#input\_grafana\_agent\_config) | The Grafan-Agent configuration | <pre>object({<br>    remote_write_urls = object({<br>      metrics = string<br>      logs    = string<br>      traces  = string<br>    })<br>    credentials = object({<br>      metrics_username = string<br>      metrics_password = string<br>      logs_username    = string<br>      logs_password    = string<br>      traces_username  = string<br>      traces_password  = string<br>    })<br>    extra_namespaces        = list(string)<br>    include_kubelet_metrics = bool<br>  })</pre> | <pre>{<br>  "credentials": {<br>    "logs_password": "",<br>    "logs_username": "",<br>    "metrics_password": "",<br>    "metrics_username": "",<br>    "traces_password": "",<br>    "traces_username": ""<br>  },<br>  "extra_namespaces": [<br>    "ingress-nginx"<br>  ],<br>  "include_kubelet_metrics": false,<br>  "remote_write_urls": {<br>    "logs": "",<br>    "metrics": "",<br>    "traces": ""<br>  }<br>}</pre> | no |
| <a name="input_grafana_agent_enabled"></a> [grafana\_agent\_enabled](#input\_grafana\_agent\_enabled) | Should Grafana-Agent be enabled | `bool` | `false` | no |
| <a name="input_group_name_prefix"></a> [group\_name\_prefix](#input\_group\_name\_prefix) | Prefix for Azure AD groups | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_ingress_config"></a> [ingress\_config](#input\_ingress\_config) | Ingress configuration | <pre>object({<br>    http_snippet              = string<br>    public_private_enabled    = bool<br>    allow_snippet_annotations = bool<br>    extra_config              = map(string)<br>    extra_headers             = map(string)<br>  })</pre> | <pre>{<br>  "allow_snippet_annotations": false,<br>  "extra_config": {},<br>  "extra_headers": {},<br>  "http_snippet": "",<br>  "public_private_enabled": false<br>}</pre> | no |
| <a name="input_ingress_healthz_enabled"></a> [ingress\_healthz\_enabled](#input\_ingress\_healthz\_enabled) | Should ingress-healthz be enabled | `bool` | `true` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Should Ingress NGINX be enabled | `bool` | `true` | no |
| <a name="input_kubernetes_default_limit_range"></a> [kubernetes\_default\_limit\_range](#input\_kubernetes\_default\_limit\_range) | Default limit range for tenant namespaces | <pre>object({<br>    default_request = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    default = object({<br>      memory = string<br>    })<br>  })</pre> | <pre>{<br>  "default": {<br>    "memory": "256Mi"<br>  },<br>  "default_request": {<br>    "cpu": "50m",<br>    "memory": "32Mi"<br>  }<br>}</pre> | no |
| <a name="input_kubernetes_network_policy_default_deny"></a> [kubernetes\_network\_policy\_default\_deny](#input\_kubernetes\_network\_policy\_default\_deny) | If network policies should by default deny cross namespace traffic | `bool` | `true` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name   = string<br>      labels = map(string)<br>      flux = object({<br>        enabled     = bool<br>        create_crds = bool<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>        github = object({<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_node_local_dns_enabled"></a> [node\_local\_dns\_enabled](#input\_node\_local\_dns\_enabled) | Should VPA be enabled | `bool` | `true` | no |
| <a name="input_node_ttl_enabled"></a> [node\_ttl\_enabled](#input\_node\_ttl\_enabled) | Should Node TTL be enabled | `bool` | `true` | no |
| <a name="input_opa_gatekeeper_config"></a> [opa\_gatekeeper\_config](#input\_opa\_gatekeeper\_config) | Configuration for OPA Gatekeeper | <pre>object({<br>    additional_excluded_namespaces = list(string)<br>    enable_default_constraints     = bool<br>    additional_constraints = list(object({<br>      excluded_namespaces = list(string)<br>      processes           = list(string)<br>    }))<br>    enable_default_assigns = bool<br>    additional_assigns = list(object({<br>      name = string<br>    }))<br>    additional_modify_sets = list(object({<br>      name = string<br>    }))<br>  })</pre> | <pre>{<br>  "additional_assigns": [],<br>  "additional_constraints": [],<br>  "additional_excluded_namespaces": [],<br>  "additional_modify_sets": [],<br>  "enable_default_assigns": true,<br>  "enable_default_constraints": true<br>}</pre> | no |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| <a name="input_priority_expander_config"></a> [priority\_expander\_config](#input\_priority\_expander\_config) | Cluster auto scaler priority expander configuration. | `map(list(string))` | `null` | no |
| <a name="input_prometheus_config"></a> [prometheus\_config](#input\_prometheus\_config) | Configuration for prometheus | <pre>object({<br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br><br>    tenant_id = string<br><br>    remote_write_authenticated = bool<br>    remote_write_url           = string<br><br>    volume_claim_size = string<br><br>    resource_selector  = list(string)<br>    namespace_selector = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Should prometheus be enabled | `bool` | `true` | no |
| <a name="input_prometheus_volume_claim_storage_class_name"></a> [prometheus\_volume\_claim\_storage\_class\_name](#input\_prometheus\_volume\_claim\_storage\_class\_name) | Configuration for prometheus volume claim storage class name | `string` | `"managed-csi-zrs"` | no |
| <a name="input_promtail_config"></a> [promtail\_config](#input\_promtail\_config) | Configuration for promtail | <pre>object({<br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br>    loki_address        = string<br>    excluded_namespaces = list(string)<br>  })</pre> | <pre>{<br>  "azure_key_vault_name": "",<br>  "excluded_namespaces": [],<br>  "identity": {<br>    "client_id": "",<br>    "resource_id": "",<br>    "tenant_id": ""<br>  },<br>  "loki_address": ""<br>}</pre> | no |
| <a name="input_promtail_enabled"></a> [promtail\_enabled](#input\_promtail\_enabled) | Should promtail be enabled | `bool` | `false` | no |
| <a name="input_reloader_enabled"></a> [reloader\_enabled](#input\_reloader\_enabled) | Should Reloader be enabled | `bool` | `true` | no |
| <a name="input_spegel_enabled"></a> [spegel\_enabled](#input\_spegel\_enabled) | Should Spegel be enabled | `bool` | `true` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |
| <a name="input_trivy_config"></a> [trivy\_config](#input\_trivy\_config) | Configuration for trivy | <pre>object({<br>    client_id   = string<br>    resource_id = string<br>  })</pre> | n/a | yes |
| <a name="input_trivy_enabled"></a> [trivy\_enabled](#input\_trivy\_enabled) | Should trivy be enabled | `bool` | `true` | no |
| <a name="input_trivy_volume_claim_storage_class_name"></a> [trivy\_volume\_claim\_storage\_class\_name](#input\_trivy\_volume\_claim\_storage\_class\_name) | Configuration for trivy volume claim storage class name | `string` | `"managed-csi-zrs"` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Velero configuration | <pre>object({<br>    azure_storage_account_name      = string<br>    azure_storage_account_container = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Should Velero be enabled | `bool` | `false` | no |
| <a name="input_vpa_enabled"></a> [vpa\_enabled](#input\_vpa\_enabled) | Should VPA be enabled | `bool` | `true` | no |

## Outputs

No outputs.
