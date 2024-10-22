# AKS Core

This module is used to create AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.110.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.110.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aad_pod_identity"></a> [aad\_pod\_identity](#module\_aad\_pod\_identity) | ../../kubernetes/aad-pod-identity | n/a |
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../kubernetes/azad-kube-proxy | n/a |
| <a name="module_azure_metrics"></a> [azure\_metrics](#module\_azure\_metrics) | ../../kubernetes/azure-metrics | n/a |
| <a name="module_azure_policy"></a> [azure\_policy](#module\_azure\_policy) | ../../kubernetes/azure-policy | n/a |
| <a name="module_azure_service_operator"></a> [azure\_service\_operator](#module\_azure\_service\_operator) | ../../kubernetes/azure-service-operator | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../../kubernetes/cert-manager | n/a |
| <a name="module_cert_manager_crd"></a> [cert\_manager\_crd](#module\_cert\_manager\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_control_plane_logs"></a> [control\_plane\_logs](#module\_control\_plane\_logs) | ../../kubernetes/control-plane-logs | n/a |
| <a name="module_datadog"></a> [datadog](#module\_datadog) | ../../kubernetes/datadog | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../kubernetes/external-dns | n/a |
| <a name="module_falco"></a> [falco](#module\_falco) | ../../kubernetes/falco | n/a |
| <a name="module_fluxcd"></a> [fluxcd](#module\_fluxcd) | ../../kubernetes/fluxcd | n/a |
| <a name="module_gatekeeper"></a> [gatekeeper](#module\_gatekeeper) | ../../kubernetes/gatekeeper | n/a |
| <a name="module_grafana_agent"></a> [grafana\_agent](#module\_grafana\_agent) | ../../kubernetes/grafana-agent | n/a |
| <a name="module_grafana_agent_crd"></a> [grafana\_agent\_crd](#module\_grafana\_agent\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_grafana_alloy"></a> [grafana\_alloy](#module\_grafana\_alloy) | ../../kubernetes/grafana-alloy | n/a |
| <a name="module_grafana_k8s_monitoring"></a> [grafana\_k8s\_monitoring](#module\_grafana\_k8s\_monitoring) | ../../kubernetes/grafana-k8s-monitoring | n/a |
| <a name="module_ingress_healthz"></a> [ingress\_healthz](#module\_ingress\_healthz) | ../../kubernetes/ingress-healthz | n/a |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | ../../kubernetes/ingress-nginx | n/a |
| <a name="module_linkerd"></a> [linkerd](#module\_linkerd) | ../../kubernetes/linkerd | n/a |
| <a name="module_linkerd_crd"></a> [linkerd\_crd](#module\_linkerd\_crd) | ../../kubernetes/helm-crd-oci | n/a |
| <a name="module_node_local_dns"></a> [node\_local\_dns](#module\_node\_local\_dns) | ../../kubernetes/node-local-dns | n/a |
| <a name="module_node_ttl"></a> [node\_ttl](#module\_node\_ttl) | ../../kubernetes/node-ttl | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ../../kubernetes/prometheus | n/a |
| <a name="module_prometheus_crd"></a> [prometheus\_crd](#module\_prometheus\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_promtail"></a> [promtail](#module\_promtail) | ../../kubernetes/promtail | n/a |
| <a name="module_reloader"></a> [reloader](#module\_reloader) | ../../kubernetes/reloader | n/a |
| <a name="module_spegel"></a> [spegel](#module\_spegel) | ../../kubernetes/spegel | n/a |
| <a name="module_telepresence"></a> [telepresence](#module\_telepresence) | ../../kubernetes/telepresence | n/a |
| <a name="module_trivy"></a> [trivy](#module\_trivy) | ../../kubernetes/trivy | n/a |
| <a name="module_trivy_crd"></a> [trivy\_crd](#module\_trivy\_crd) | ../../kubernetes/helm-crd | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ../../kubernetes/velero | n/a |
| <a name="module_vpa"></a> [vpa](#module\_vpa) | ../../kubernetes/vpa | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.aks_core_extras](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubectl_manifest.priority_expander](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_cluster_role.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.get_nodes](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.get_vpa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.list_namespaces](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.logs_cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.logs_external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.logs_ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.top](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.trivy_reports](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.cluster_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.cluster_view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.get_nodes](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_limit_range.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/limit_range) | resource |
| [kubernetes_namespace.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [kubernetes_network_policy.allow_egress_ingress_datadog](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.allow_egress_ingress_grafana_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.allow_egress_traffic_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/network_policy) | resource |
| [kubernetes_role_binding.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.logs_cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.logs_external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.logs_ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.top](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.trivy_reports](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.vpa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |
| [kubernetes_service_account_v1.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/service_account_v1) | resource |
| [kubernetes_storage_class.additional](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.azurefile_zrs_premium](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.azurefile_zrs_standard](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.zrs_premium](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.zrs_standard](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/storage_class) | resource |
| [azuread_group.aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/data-sources/client_config) | data source |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/data-sources/container_registry) | data source |
| [azurerm_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/data-sources/dns_zone) | data source |
| [azurerm_key_vault.core](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.global](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/data-sources/resource_group) | data source |
| [azurerm_user_assigned_identity.tenant](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for aad groups | <pre>object({<br/>    view = map(any)<br/>    edit = map(any)<br/>    cluster_admin = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>    cluster_view = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>    aks_managed_identity = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_aad_pod_identity_config"></a> [aad\_pod\_identity\_config](#input\_aad\_pod\_identity\_config) | Configuration for aad pod identity | <pre>map(object({<br/>    id        = string<br/>    client_id = string<br/>  }))</pre> | n/a | yes |
| <a name="input_aad_pod_identity_enabled"></a> [aad\_pod\_identity\_enabled](#input\_aad\_pod\_identity\_enabled) | Should aad-pod-identity be enabled | `bool` | `true` | no |
| <a name="input_acr_name_override"></a> [acr\_name\_override](#input\_acr\_name\_override) | Override default name of ACR | `string` | `""` | no |
| <a name="input_additional_storage_classes"></a> [additional\_storage\_classes](#input\_additional\_storage\_classes) | List of additional storage classes to create | <pre>list(object({<br/>    name           = string<br/>    provisioner    = string<br/>    reclaim_policy = string<br/>    binding_mode   = string<br/>    sku_name       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_aks_name_suffix"></a> [aks\_name\_suffix](#input\_aks\_name\_suffix) | The suffix for the aks clusters | `number` | n/a | yes |
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | The azad-kube-proxy configuration | <pre>object({<br/>    fqdn        = string<br/>    allowed_ips = list(string)<br/>  })</pre> | <pre>{<br/>  "allowed_ips": [],<br/>  "fqdn": ""<br/>}</pre> | no |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_azure_metrics_enabled"></a> [azure\_metrics\_enabled](#input\_azure\_metrics\_enabled) | Should AZ Metrics be enabled | `bool` | `true` | no |
| <a name="input_azure_policy_config"></a> [azure\_policy\_config](#input\_azure\_policy\_config) | A list of Azure policy mutations to create and include in the XKS policy set definition | <pre>object({<br/>    exclude_namespaces = list(string)<br/>    mutations = list(object({<br/>      name         = string<br/>      display_name = string<br/>      template     = string<br/>    }))<br/>  })</pre> | <pre>{<br/>  "exclude_namespaces": [<br/>    "linkerd",<br/>    "linkerd-cni",<br/>    "velero",<br/>    "grafana-agent"<br/>  ],<br/>  "mutations": [<br/>    {<br/>      "display_name": "Containers should not use privilege escalation",<br/>      "name": "ContainerNoPrivilegeEscalation",<br/>      "template": "container-disallow-privilege-escalation.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Containers should drop disallowed capabilities",<br/>      "name": "ContainerDropCapabilities",<br/>      "template": "container-drop-capabilities.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Containers should use a read-only root filesystem",<br/>      "name": "ContainerReadOnlyRootFs",<br/>      "template": "container-read-only-root-fs.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Ephemeral containers should not use privilege escalation",<br/>      "name": "EphemeralContainerNoPrivilegeEscalation",<br/>      "template": "ephemeral-container-disallow-privilege-escalation.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Ephemeral containers should drop disallowed capabilities",<br/>      "name": "EphemeralContainerDropCapabilities",<br/>      "template": "ephemeral-container-drop-capabilities.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Ephemeral containers should use a read-only root filesystem",<br/>      "name": "EphemeralContainerReadOnlyRootFs",<br/>      "template": "ephemeral-container-read-only-root-fs.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Init containers should not use privilege escalation",<br/>      "name": "InitContainerNoPrivilegeEscalation",<br/>      "template": "init-container-disallow-privilege-escalation.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Init containers should drop disallowed capabilities",<br/>      "name": "InitContainerDropCapabilities",<br/>      "template": "init-container-drop-capabilities.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Init containers should use a read-only root filesystem",<br/>      "name": "InitContainerReadOnlyRootFs",<br/>      "template": "init-container-read-only-root-fs.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Pods should use an allowed seccomp profile",<br/>      "name": "PodDefaultSecComp",<br/>      "template": "k8s-pod-default-seccomp.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Pods should not automount service account tokens",<br/>      "name": "PodServiceAccountTokenNoAutoMount",<br/>      "template": "k8s-pod-serviceaccount-token-false.yaml.tpl"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | If the Azure Policy for Kubernetes add-on should be enabled | `bool` | `false` | no |
| <a name="input_azure_service_operator_config"></a> [azure\_service\_operator\_config](#input\_azure\_service\_operator\_config) | Azure Service Operator configuration | <pre>object({<br/>    cluster_config = optional(object({<br/>      sync_period    = optional(string, "1m")<br/>      enable_metrics = optional(bool, false)<br/>      crd_pattern    = optional(string, "") # never set this to '*', limit this to the resources that are actually needed<br/>    }), {})<br/>    tenant_namespaces = optional(list(object({<br/>      name = string<br/>    })), [])<br/>  })</pre> | `{}` | no |
| <a name="input_azure_service_operator_enabled"></a> [azure\_service\_operator\_enabled](#input\_azure\_service\_operator\_enabled) | If Azure Service Operator should be enabled | `bool` | `false` | no |
| <a name="input_cert_manager_config"></a> [cert\_manager\_config](#input\_cert\_manager\_config) | Cert Manager configuration, the first item in the list is the main domain | <pre>object({<br/>    notification_email = string<br/>    dns_zone           = list(string)<br/>  })</pre> | n/a | yes |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Should Cert Manager be enabled | `bool` | `true` | no |
| <a name="input_cilium_enabled"></a> [cilium\_enabled](#input\_cilium\_enabled) | If enabled, will use Azure CNI with Cilium instead of kubenet | `bool` | `true` | no |
| <a name="input_control_plane_logs_config"></a> [control\_plane\_logs\_config](#input\_control\_plane\_logs\_config) | Configuration for control plane log | <pre>object({<br>    azure_key_vault_name = string<br>    eventhub_hostname    = string<br>    eventhub_name        = string<br>  })</pre> | <pre>{<br>  "azure_key_vault_name": "",<br>  "eventhub_hostname": "",<br>  "eventhub_name": ""<br>}</pre> | no |
| <a name="input_control_plane_logs_enabled"></a> [control\_plane\_logs\_enabled](#input\_control\_plane\_logs\_enabled) | Should Control plan be enabled | `bool` | `false` | no |
| <a name="input_core_name"></a> [core\_name](#input\_core\_name) | The name for the core infrastructure | `string` | n/a | yes |
| <a name="input_coredns_upstream"></a> [coredns\_upstream](#input\_coredns\_upstream) | Should coredns be used as the last route instead of upstream dns? | `bool` | `false` | no |
| <a name="input_datadog_config"></a> [datadog\_config](#input\_datadog\_config) | Datadog configuration | <pre>object({<br/>    azure_key_vault_name = string<br/>    datadog_site         = string<br/>    namespaces           = list(string)<br/>    apm_ignore_resources = list(string)<br/>  })</pre> | <pre>{<br/>  "apm_ignore_resources": [<br/>    ""<br/>  ],<br/>  "azure_key_vault_name": "",<br/>  "datadog_site": "",<br/>  "namespaces": [<br/>    ""<br/>  ]<br/>}</pre> | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Should Datadog be enabled | `bool` | `false` | no |
| <a name="input_defender_enabled"></a> [defender\_enabled](#input\_defender\_enabled) | If Defender for Containers should be enabled | `bool` | `false` | no |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | List of DNS Zones | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Should External DNS be enabled | `bool` | `true` | no |
| <a name="input_external_dns_hostname"></a> [external\_dns\_hostname](#input\_external\_dns\_hostname) | hostname for ingress-nginx to use for external-dns | `string` | `""` | no |
| <a name="input_falco_enabled"></a> [falco\_enabled](#input\_falco\_enabled) | Should Falco be enabled | `bool` | `true` | no |
| <a name="input_fluxcd_config"></a> [fluxcd\_config](#input\_fluxcd\_config) | Configuration for FluxCD | <pre>object({<br/>    git_provider = object({<br/>      organization        = string<br/>      type                = optional(string, "azuredevops")<br/>      include_tenant_name = optional(bool, false)<br/>      github = optional(object({<br/>        application_id  = number<br/>        installation_id = number<br/>        private_key     = string<br/>      }))<br/>      azure_devops = optional(object({<br/>        pat = string<br/>      }))<br/>    })<br/>    bootstrap = object({<br/>      disable_secret_creation = optional(bool, true)<br/>      project                 = optional(string)<br/>      repository              = string<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_fluxcd_enabled"></a> [fluxcd\_enabled](#input\_fluxcd\_enabled) | Should fluxcd be enabled | `bool` | `true` | no |
| <a name="input_gatekeeper_config"></a> [gatekeeper\_config](#input\_gatekeeper\_config) | Configuration for OPA Gatekeeper | <pre>object({<br/>    exclude_namespaces = list(string)<br/>  })</pre> | <pre>{<br/>  "exclude_namespaces": []<br/>}</pre> | no |
| <a name="input_gatekeeper_enabled"></a> [gatekeeper\_enabled](#input\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| <a name="input_global_location_short"></a> [global\_location\_short](#input\_global\_location\_short) | The Azure region short name where the global resources resides. | `string` | n/a | yes |
| <a name="input_grafana_agent_config"></a> [grafana\_agent\_config](#input\_grafana\_agent\_config) | The Grafan-Agent configuration | <pre>object({<br/>    remote_write_urls = object({<br/>      metrics = string<br/>      logs    = string<br/>      traces  = string<br/>    })<br/>    credentials = object({<br/>      metrics_username = string<br/>      metrics_password = string<br/>      logs_username    = string<br/>      logs_password    = string<br/>      traces_username  = string<br/>      traces_password  = string<br/>    })<br/>    extra_namespaces        = list(string)<br/>    include_kubelet_metrics = bool<br/>  })</pre> | <pre>{<br/>  "credentials": {<br/>    "logs_password": "",<br/>    "logs_username": "",<br/>    "metrics_password": "",<br/>    "metrics_username": "",<br/>    "traces_password": "",<br/>    "traces_username": ""<br/>  },<br/>  "extra_namespaces": [<br/>    "ingress-nginx"<br/>  ],<br/>  "include_kubelet_metrics": false,<br/>  "remote_write_urls": {<br/>    "logs": "",<br/>    "metrics": "",<br/>    "traces": ""<br/>  }<br/>}</pre> | no |
| <a name="input_grafana_agent_enabled"></a> [grafana\_agent\_enabled](#input\_grafana\_agent\_enabled) | Should Grafana-Agent be enabled | `bool` | `false` | no |
| <a name="input_grafana_alloy_config"></a> [grafana\_alloy\_config](#input\_grafana\_alloy\_config) | Grafana Alloy config | <pre>object({<br/>    azure_key_vault_name                = string<br/>    keyvault_secret_name                = string<br/>    cluster_name                        = string<br/>    grafana_otelcol_auth_basic_username = string<br/>    grafana_otelcol_exporter_endpoint   = string<br/>  })</pre> | n/a | yes |
| <a name="input_grafana_alloy_enabled"></a> [grafana\_alloy\_enabled](#input\_grafana\_alloy\_enabled) | Should Grafana-Alloy be enabled | `bool` | `false` | no |
| <a name="input_grafana_k8s_monitor_config"></a> [grafana\_k8s\_monitor\_config](#input\_grafana\_k8s\_monitor\_config) | Grafana k8s monitor chart config | <pre>object({<br/>    azure_key_vault_name          = string<br/>    grafana_cloud_prometheus_host = optional(string, "")<br/>    grafana_cloud_loki_host       = optional(string, "")<br/>    grafana_cloud_tempo_host      = optional(string, "")<br/>    cluster_name                  = string<br/>    include_namespaces            = optional(string, "")<br/>    include_namespaces_piped      = optional(string, "")<br/>    exclude_namespaces            = optional(string, "")<br/>  })</pre> | n/a | yes |
| <a name="input_grafana_k8s_monitoring_enabled"></a> [grafana\_k8s\_monitoring\_enabled](#input\_grafana\_k8s\_monitoring\_enabled) | Should Grafana-k8s-chart be enabled/deployed | `bool` | `false` | no |
| <a name="input_group_name_prefix"></a> [group\_name\_prefix](#input\_group\_name\_prefix) | Prefix for Azure AD groups | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_ingress_healthz_enabled"></a> [ingress\_healthz\_enabled](#input\_ingress\_healthz\_enabled) | Should ingress-healthz be enabled | `bool` | `true` | no |
| <a name="input_ingress_nginx_config"></a> [ingress\_nginx\_config](#input\_ingress\_nginx\_config) | Ingress configuration | <pre>object({<br/>    private_ingress_enabled = bool<br/>    customization = optional(object({<br/>      allow_snippet_annotations = bool<br/>      http_snippet              = string<br/>      extra_config              = map(string)<br/>      extra_headers             = map(string)<br/>    }))<br/>    customization_private = optional(object({<br/>      allow_snippet_annotations = optional(bool)<br/>      http_snippet              = optional(string)<br/>      extra_config              = optional(map(string))<br/>      extra_headers             = optional(map(string))<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Should Ingress NGINX be enabled | `bool` | `true` | no |
| <a name="input_kubernetes_default_limit_range"></a> [kubernetes\_default\_limit\_range](#input\_kubernetes\_default\_limit\_range) | Default limit range for tenant namespaces | <pre>object({<br/>    default_request = object({<br/>      cpu    = string<br/>      memory = string<br/>    })<br/>    default = object({<br/>      memory = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "default": {<br/>    "memory": "256Mi"<br/>  },<br/>  "default_request": {<br/>    "cpu": "50m",<br/>    "memory": "32Mi"<br/>  }<br/>}</pre> | no |
| <a name="input_kubernetes_network_policy_default_deny"></a> [kubernetes\_network\_policy\_default\_deny](#input\_kubernetes\_network\_policy\_default\_deny) | If network policies should by default deny cross namespace traffic | `bool` | `true` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_mirrord_enabled"></a> [mirrord\_enabled](#input\_mirrord\_enabled) | Should mirrord be enabled | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br/>    object({<br/>      name   = string<br/>      labels = map(string)<br/>      flux = optional(object({<br/>        provider            = string<br/>        project             = optional(string)<br/>        repository          = string<br/>        include_tenant_name = optional(bool, false)<br/>        create_crds         = optional(bool, false)<br/>      }))<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_node_local_dns_enabled"></a> [node\_local\_dns\_enabled](#input\_node\_local\_dns\_enabled) | Should VPA be enabled | `bool` | `true` | no |
| <a name="input_node_ttl_enabled"></a> [node\_ttl\_enabled](#input\_node\_ttl\_enabled) | Should Node TTL be enabled | `bool` | `true` | no |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_priority_expander_config"></a> [priority\_expander\_config](#input\_priority\_expander\_config) | Cluster auto scaler priority expander configuration. | `map(list(string))` | `null` | no |
| <a name="input_prometheus_config"></a> [prometheus\_config](#input\_prometheus\_config) | Configuration for prometheus | <pre>object({<br/>    azure_key_vault_name       = string<br/>    tenant_id                  = string<br/>    remote_write_authenticated = bool<br/>    remote_write_url           = string<br/>    volume_claim_size          = string<br/>    resource_selector          = list(string)<br/>    namespace_selector         = list(string)<br/>  })</pre> | n/a | yes |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Should prometheus be enabled | `bool` | `true` | no |
| <a name="input_prometheus_volume_claim_storage_class_name"></a> [prometheus\_volume\_claim\_storage\_class\_name](#input\_prometheus\_volume\_claim\_storage\_class\_name) | Configuration for prometheus volume claim storage class name | `string` | `"managed-csi-zrs"` | no |
| <a name="input_promtail_config"></a> [promtail\_config](#input\_promtail\_config) | Configuration for promtail | <pre>object({<br/>    azure_key_vault_name = string<br/>    loki_address         = string<br/>    excluded_namespaces  = list(string)<br/>  })</pre> | <pre>{<br/>  "azure_key_vault_name": "",<br/>  "excluded_namespaces": [],<br/>  "loki_address": ""<br/>}</pre> | no |
| <a name="input_promtail_enabled"></a> [promtail\_enabled](#input\_promtail\_enabled) | Should promtail be enabled | `bool` | `false` | no |
| <a name="input_reloader_enabled"></a> [reloader\_enabled](#input\_reloader\_enabled) | Should Reloader be enabled | `bool` | `true` | no |
| <a name="input_spegel_enabled"></a> [spegel\_enabled](#input\_spegel\_enabled) | Should Spegel be enabled | `bool` | `true` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |
| <a name="input_telepresence_config"></a> [telepresence\_config](#input\_telepresence\_config) | Config to use when deploying traffic manager to the cluster | <pre>object({<br/>    allow_conflicting_subnets = optional(list(string), [])<br/>    client_rbac = object({<br/>      create     = bool<br/>      namespaced = bool<br/>      namespaces = optional(list(string), ["ambassador"])<br/>      subjects   = optional(list(string), [])<br/>    })<br/>    manager_rbac = object({<br/>      create     = bool<br/>      namespaced = bool<br/>      namespaces = optional(list(string), [])<br/>    })<br/>  })</pre> | <pre>{<br/>  "client_rbac": {<br/>    "create": false,<br/>    "namespaced": false<br/>  },<br/>  "manager_rbac": {<br/>    "create": true,<br/>    "namespaced": true<br/>  }<br/>}</pre> | no |
| <a name="input_telepresence_enabled"></a> [telepresence\_enabled](#input\_telepresence\_enabled) | Should Telepresence be enabled | `bool` | `false` | no |
| <a name="input_trivy_config"></a> [trivy\_config](#input\_trivy\_config) | Configuration for trivy | <pre>object({<br/>    starboard_exporter_enabled = optional(bool, true)<br/>  })</pre> | n/a | yes |
| <a name="input_trivy_enabled"></a> [trivy\_enabled](#input\_trivy\_enabled) | Should trivy be enabled | `bool` | `true` | no |
| <a name="input_trivy_volume_claim_storage_class_name"></a> [trivy\_volume\_claim\_storage\_class\_name](#input\_trivy\_volume\_claim\_storage\_class\_name) | Configuration for trivy volume claim storage class name | `string` | `"managed-csi-zrs"` | no |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |
| <a name="input_use_private_ingress"></a> [use\_private\_ingress](#input\_use\_private\_ingress) | If true, private ingress will be used by azad-kube-proxy | `bool` | `false` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Velero configuration | <pre>object({<br/>    azure_storage_account_name      = string<br/>    azure_storage_account_container = string<br/>  })</pre> | n/a | yes |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Should Velero be enabled | `bool` | `false` | no |
| <a name="input_vpa_enabled"></a> [vpa\_enabled](#input\_vpa\_enabled) | Should VPA be enabled | `bool` | `true` | no |

## Outputs

No outputs.
