# AKS Core

This module is used to create AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.82.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.5.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.17.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.13.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.6.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.82.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.6.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aad_pod_identity"></a> [aad\_pod\_identity](#module\_aad\_pod\_identity) | ../../kubernetes/aad-pod-identity | n/a |
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../kubernetes/azad-kube-proxy | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../../kubernetes/cert-manager | n/a |
| <a name="module_csi_secrets_store_provider_azure"></a> [csi\_secrets\_store\_provider\_azure](#module\_csi\_secrets\_store\_provider\_azure) | ../../kubernetes/csi-secrets-store-provider-azure | n/a |
| <a name="module_datadog"></a> [datadog](#module\_datadog) | ../../kubernetes/datadog | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../kubernetes/external-dns | n/a |
| <a name="module_falco"></a> [falco](#module\_falco) | ../../kubernetes/falco | n/a |
| <a name="module_fluxcd_v1_azure_devops"></a> [fluxcd\_v1\_azure\_devops](#module\_fluxcd\_v1\_azure\_devops) | ../../kubernetes/fluxcd-v1 | n/a |
| <a name="module_fluxcd_v2_azure_devops"></a> [fluxcd\_v2\_azure\_devops](#module\_fluxcd\_v2\_azure\_devops) | ../../kubernetes/fluxcd-v2-azdo | n/a |
| <a name="module_fluxcd_v2_github"></a> [fluxcd\_v2\_github](#module\_fluxcd\_v2\_github) | ../../kubernetes/fluxcd-v2-github | n/a |
| <a name="module_ingress_healthz"></a> [ingress\_healthz](#module\_ingress\_healthz) | ../../kubernetes/ingress-healthz | n/a |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | ../../kubernetes/ingress-nginx | n/a |
| <a name="module_linkerd"></a> [linkerd](#module\_linkerd) | ../../kubernetes/linkerd | n/a |
| <a name="module_new_relic"></a> [new\_relic](#module\_new\_relic) | ../../kubernetes/new-relic | n/a |
| <a name="module_opa_gatekeeper"></a> [opa\_gatekeeper](#module\_opa\_gatekeeper) | ../../kubernetes/opa-gatekeeper | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ../../kubernetes/prometheus | n/a |
| <a name="module_reloader"></a> [reloader](#module\_reloader) | ../../kubernetes/reloader | n/a |
| <a name="module_starboard"></a> [starboard](#module\_starboard) | ../../kubernetes/starboard | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ../../kubernetes/velero | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.aks_core_extras](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_cluster_role.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.list_namespaces](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.top](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.cluster_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.cluster_view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_limit_range.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/limit_range) | resource |
| [kubernetes_namespace.service_accounts](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/namespace) | resource |
| [kubernetes_network_policy.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/network_policy) | resource |
| [kubernetes_role_binding.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.sa_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.sa_helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.top](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/role_binding) | resource |
| [kubernetes_service_account.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/service_account) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for aad groups | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>    aks_managed_identity = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_aad_pod_identity_config"></a> [aad\_pod\_identity\_config](#input\_aad\_pod\_identity\_config) | Configuration for aad pod identity | <pre>map(object({<br>    id        = string<br>    client_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_aad_pod_identity_enabled"></a> [aad\_pod\_identity\_enabled](#input\_aad\_pod\_identity\_enabled) | Should aad-pod-identity be enabled | `bool` | `true` | no |
| <a name="input_aks_name_suffix"></a> [aks\_name\_suffix](#input\_aks\_name\_suffix) | The suffix for the aks clusters | `number` | n/a | yes |
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | The azad-kube-proxy configuration | <pre>object({<br>    fqdn                  = string<br>    dashboard             = string<br>    azure_ad_group_prefix = string<br>    allowed_ips           = list(string)<br>    azure_ad_app = object({<br>      client_id     = string<br>      client_secret = string<br>      tenant_id     = string<br>    })<br>    k8dash_config = object({<br>      client_id     = string<br>      client_secret = string<br>      scope         = string<br>    })<br>  })</pre> | <pre>{<br>  "allowed_ips": [],<br>  "azure_ad_app": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "tenant_id": ""<br>  },<br>  "azure_ad_group_prefix": "",<br>  "dashboard": "",<br>  "fqdn": "",<br>  "k8dash_config": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "scope": ""<br>  }<br>}</pre> | no |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_cert_manager_config"></a> [cert\_manager\_config](#input\_cert\_manager\_config) | Cert Manager configuration | <pre>object({<br>    notification_email = string<br>    dns_zone           = string<br>  })</pre> | n/a | yes |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Should Cert Manager be enabled | `bool` | `true` | no |
| <a name="input_csi_secrets_store_provider_azure_enabled"></a> [csi\_secrets\_store\_provider\_azure\_enabled](#input\_csi\_secrets\_store\_provider\_azure\_enabled) | Should csi-secrets-store-provider-azure be enabled | `bool` | `true` | no |
| <a name="input_datadog_config"></a> [datadog\_config](#input\_datadog\_config) | Datadog configuration | <pre>object({<br>    datadog_site     = string<br>    api_key          = string<br>    app_key          = string<br>    extra_namespaces = list(string)<br>  })</pre> | <pre>{<br>  "api_key": "",<br>  "app_key": "",<br>  "datadog_site": "",<br>  "extra_namespaces": [<br>    ""<br>  ]<br>}</pre> | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Should Datadog be enabled | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_external_dns_config"></a> [external\_dns\_config](#input\_external\_dns\_config) | External DNS configuration | <pre>object({<br>    client_id   = string<br>    resource_id = string<br>  })</pre> | n/a | yes |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Should External DNS be enabled | `bool` | `true` | no |
| <a name="input_falco_enabled"></a> [falco\_enabled](#input\_falco\_enabled) | Should Falco be enabled | `bool` | `true` | no |
| <a name="input_fluxcd_v1_config"></a> [fluxcd\_v1\_config](#input\_fluxcd\_v1\_config) | Configuration for fluxcd-v1 | <pre>object({<br>    flux_status_enabled = bool<br>    branch              = string<br>    azure_devops = object({<br>      pat  = string<br>      org  = string<br>      proj = string<br>    })<br>  })</pre> | <pre>{<br>  "azure_devops": {<br>    "org": "",<br>    "pat": "",<br>    "proj": ""<br>  },<br>  "branch": "main",<br>  "flux_status_enabled": false<br>}</pre> | no |
| <a name="input_fluxcd_v1_enabled"></a> [fluxcd\_v1\_enabled](#input\_fluxcd\_v1\_enabled) | Should fluxcd-v1 be enabled | `bool` | `false` | no |
| <a name="input_fluxcd_v2_config"></a> [fluxcd\_v2\_config](#input\_fluxcd\_v2\_config) | Configuration for fluxcd-v2 | <pre>object({<br>    type = string<br>    github = object({<br>      org             = string<br>      app_id          = number<br>      installation_id = number<br>      private_key     = string<br>    })<br>    azure_devops = object({<br>      pat  = string<br>      org  = string<br>      proj = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_fluxcd_v2_enabled"></a> [fluxcd\_v2\_enabled](#input\_fluxcd\_v2\_enabled) | Should fluxcd-v2 be enabled | `bool` | `true` | no |
| <a name="input_ingress_config"></a> [ingress\_config](#input\_ingress\_config) | Ingress configuration | <pre>object({<br>    http_snippet           = string<br>    public_private_enabled = bool<br>  })</pre> | <pre>{<br>  "http_snippet": "",<br>  "public_private_enabled": false<br>}</pre> | no |
| <a name="input_ingress_healthz_enabled"></a> [ingress\_healthz\_enabled](#input\_ingress\_healthz\_enabled) | Should ingress-healthz be enabled | `bool` | `true` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Should Ingress NGINX be enabled | `bool` | `true` | no |
| <a name="input_kube_state_metrics_namepsaces_extras"></a> [kube\_state\_metrics\_namepsaces\_extras](#input\_kube\_state\_metrics\_namepsaces\_extras) | Comma-separated list of namespaces to be enabled except the ones defined by default. | `list(string)` | `[]` | no |
| <a name="input_kubernetes_default_limit_range"></a> [kubernetes\_default\_limit\_range](#input\_kubernetes\_default\_limit\_range) | Default limit range for tenant namespaces | <pre>object({<br>    default_request = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    default = object({<br>      memory = string<br>    })<br>  })</pre> | <pre>{<br>  "default": {<br>    "memory": "256Mi"<br>  },<br>  "default_request": {<br>    "cpu": "50m",<br>    "memory": "32Mi"<br>  }<br>}</pre> | no |
| <a name="input_kubernetes_network_policy_default_deny"></a> [kubernetes\_network\_policy\_default\_deny](#input\_kubernetes\_network\_policy\_default\_deny) | If network policies should by default deny cross namespace traffic | `bool` | `false` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name   = string<br>      labels = map(string)<br>      flux = object({<br>        enabled     = bool<br>        create_crds = bool<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>        github = object({<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_new_relic_config"></a> [new\_relic\_config](#input\_new\_relic\_config) | Configuration for New Relic | <pre>object({<br>    license_key = string<br>  })</pre> | <pre>{<br>  "license_key": ""<br>}</pre> | no |
| <a name="input_new_relic_enabled"></a> [new\_relic\_enabled](#input\_new\_relic\_enabled) | Should New Relic be enabled | `bool` | `false` | no |
| <a name="input_opa_gatekeeper_config"></a> [opa\_gatekeeper\_config](#input\_opa\_gatekeeper\_config) | Configuration for OPA Gatekeeper | <pre>object({<br>    additional_excluded_namespaces = list(string)<br>    enable_default_constraints     = bool<br>    additional_constraints = list(object({<br>      excluded_namespaces = list(string)<br>      processes           = list(string)<br>    }))<br>    enable_default_assigns = bool<br>    additional_assigns = list(object({<br>      name = string<br>    }))<br>  })</pre> | <pre>{<br>  "additional_assigns": [],<br>  "additional_constraints": [],<br>  "additional_excluded_namespaces": [],<br>  "enable_default_assigns": true,<br>  "enable_default_constraints": true<br>}</pre> | no |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| <a name="input_prometheus_config"></a> [prometheus\_config](#input\_prometheus\_config) | Configuration for prometheus | <pre>object({<br>    remote_write_enabled = bool<br>    remote_write_url     = string<br>    tenant_id            = string<br><br>    volume_claim_enabled            = bool<br>    volume_claim_storage_class_name = string<br>    volume_claim_size               = string<br><br>    alertmanager_enabled = bool<br><br>    resource_selector  = list(string)<br>    namespace_selector = list(string)<br><br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Should prometheus be enabled | `bool` | `true` | no |
| <a name="input_reloader_enabled"></a> [reloader\_enabled](#input\_reloader\_enabled) | Should Reloader be enabled | `bool` | `true` | no |
| <a name="input_starboard_enabled"></a> [starboard\_enabled](#input\_starboard\_enabled) | Should Starboard be enabled | `bool` | `true` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Velero configuration | <pre>object({<br>    azure_storage_account_name      = string<br>    azure_storage_account_container = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Should Velero be enabled | `bool` | `false` | no |

## Outputs

No outputs.
