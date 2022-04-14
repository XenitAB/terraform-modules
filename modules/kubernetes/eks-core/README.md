# EKS Core

This module is used to configure EKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.6.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.11.2 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.21.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.13.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.6.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../kubernetes/azad-kube-proxy | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../../kubernetes/cert-manager | n/a |
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | ../../kubernetes/cluster-autoscaler | n/a |
| <a name="module_csi_secrets_store_provider_aws"></a> [csi\_secrets\_store\_provider\_aws](#module\_csi\_secrets\_store\_provider\_aws) | ../../kubernetes/csi-secrets-store-provider-aws | n/a |
| <a name="module_datadog"></a> [datadog](#module\_datadog) | ../../kubernetes/datadog | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../kubernetes/external-dns | n/a |
| <a name="module_falco"></a> [falco](#module\_falco) | ../../kubernetes/falco | n/a |
| <a name="module_fluxcd_v2_azure_devops"></a> [fluxcd\_v2\_azure\_devops](#module\_fluxcd\_v2\_azure\_devops) | ../../kubernetes/fluxcd-v2-azdo | n/a |
| <a name="module_fluxcd_v2_github"></a> [fluxcd\_v2\_github](#module\_fluxcd\_v2\_github) | ../../kubernetes/fluxcd-v2-github | n/a |
| <a name="module_ingress_healthz"></a> [ingress\_healthz](#module\_ingress\_healthz) | ../../kubernetes/ingress-healthz | n/a |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | ../../kubernetes/ingress-nginx | n/a |
| <a name="module_linkerd"></a> [linkerd](#module\_linkerd) | ../../kubernetes/linkerd | n/a |
| <a name="module_opa_gatekeeper"></a> [opa\_gatekeeper](#module\_opa\_gatekeeper) | ../../kubernetes/opa-gatekeeper | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ../../kubernetes/prometheus | n/a |
| <a name="module_promtail"></a> [promtail](#module\_promtail) | ../../kubernetes/promtail | n/a |
| <a name="module_reloader"></a> [reloader](#module\_reloader) | ../../kubernetes/reloader | n/a |
| <a name="module_starboard"></a> [starboard](#module\_starboard) | ../../kubernetes/starboard | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ../../kubernetes/velero | n/a |
| <a name="module_vpa"></a> [vpa](#module\_vpa) | ../../kubernetes/vpa | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.aks_core_extras](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubernetes_cluster_role.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.get_node](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.list_namespaces](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.starboard_reports](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.top](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.cluster_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.cluster_view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_limit_range.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/limit_range) | resource |
| [kubernetes_namespace.service_accounts](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [kubernetes_network_policy.allow_egress_datadog](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.allow_egress_ingress_grafana_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/network_policy) | resource |
| [kubernetes_role_binding.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.get_node](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.sa_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.sa_helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.starboard_reports](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.top](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/role_binding) | resource |
| [kubernetes_service_account.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/service_account) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/4.6.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for aad groups | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | The azad-kube-proxy configuration | <pre>object({<br>    fqdn                  = string<br>    azure_ad_group_prefix = string<br>    allowed_ips           = list(string)<br>    azure_ad_app = object({<br>      client_id     = string<br>      client_secret = string<br>      tenant_id     = string<br>    })<br>  })</pre> | <pre>{<br>  "allowed_ips": [],<br>  "azure_ad_app": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "tenant_id": ""<br>  },<br>  "azure_ad_group_prefix": "",<br>  "fqdn": ""<br>}</pre> | no |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_cert_manager_config"></a> [cert\_manager\_config](#input\_cert\_manager\_config) | Cert Manager configuration, the first item in the list is the main domain | <pre>object({<br>    notification_email = string<br>    dns_zone           = list(string)<br>    role_arn           = string<br>  })</pre> | n/a | yes |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Should Cert Manager be enabled | `bool` | `true` | no |
| <a name="input_cluster_autoscaler_config"></a> [cluster\_autoscaler\_config](#input\_cluster\_autoscaler\_config) | Cluster Autoscaler configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_cluster_autoscaler_enabled"></a> [cluster\_autoscaler\_enabled](#input\_cluster\_autoscaler\_enabled) | Should Cluster Autoscaler be enabled | `bool` | `true` | no |
| <a name="input_csi_secrets_store_provider_aws_enabled"></a> [csi\_secrets\_store\_provider\_aws\_enabled](#input\_csi\_secrets\_store\_provider\_aws\_enabled) | Should csi-secrets-store-provider-aws be enabled | `bool` | `true` | no |
| <a name="input_datadog_config"></a> [datadog\_config](#input\_datadog\_config) | Datadog configuration | <pre>object({<br>    datadog_site     = string<br>    api_key          = string<br>    app_key          = string<br>    extra_namespaces = list(string)<br>  })</pre> | <pre>{<br>  "api_key": "",<br>  "app_key": "",<br>  "datadog_site": "",<br>  "extra_namespaces": [<br>    ""<br>  ]<br>}</pre> | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Should Datadog be enabled | `bool` | `false` | no |
| <a name="input_eks_name_suffix"></a> [eks\_name\_suffix](#input\_eks\_name\_suffix) | The suffix for the eks clusters | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_external_dns_config"></a> [external\_dns\_config](#input\_external\_dns\_config) | External DNS configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Should External DNS be enabled | `bool` | `true` | no |
| <a name="input_falco_enabled"></a> [falco\_enabled](#input\_falco\_enabled) | Should Falco be enabled | `bool` | `false` | no |
| <a name="input_fluxcd_v2_config"></a> [fluxcd\_v2\_config](#input\_fluxcd\_v2\_config) | Configuration for fluxcd-v2 | <pre>object({<br>    type = string<br>    github = object({<br>      org             = string<br>      app_id          = number<br>      installation_id = number<br>      private_key     = string<br>    })<br>    azure_devops = object({<br>      pat  = string<br>      org  = string<br>      proj = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_fluxcd_v2_enabled"></a> [fluxcd\_v2\_enabled](#input\_fluxcd\_v2\_enabled) | Should fluxcd-v2 be enabled | `bool` | `true` | no |
| <a name="input_grafana_agent_enabled"></a> [grafana\_agent\_enabled](#input\_grafana\_agent\_enabled) | Should Grafana-Agent be enabled | `bool` | `false` | no |
| <a name="input_ingress_config"></a> [ingress\_config](#input\_ingress\_config) | Ingress configuration | <pre>object({<br>    http_snippet              = string<br>    public_private_enabled    = bool<br>    allow_snippet_annotations = bool<br>  })</pre> | <pre>{<br>  "allow_snippet_annotations": false,<br>  "http_snippet": "",<br>  "public_private_enabled": false<br>}</pre> | no |
| <a name="input_ingress_healthz_enabled"></a> [ingress\_healthz\_enabled](#input\_ingress\_healthz\_enabled) | Should ingress-healthz be enabled | `bool` | `true` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Should Ingress NGINX be enabled | `bool` | `true` | no |
| <a name="input_kubernetes_default_limit_range"></a> [kubernetes\_default\_limit\_range](#input\_kubernetes\_default\_limit\_range) | Default limit range for tenant namespaces | <pre>object({<br>    default_request = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    default = object({<br>      memory = string<br>    })<br>  })</pre> | <pre>{<br>  "default": {<br>    "memory": "256Mi"<br>  },<br>  "default_request": {<br>    "cpu": "50m",<br>    "memory": "32Mi"<br>  }<br>}</pre> | no |
| <a name="input_kubernetes_network_policy_default_deny"></a> [kubernetes\_network\_policy\_default\_deny](#input\_kubernetes\_network\_policy\_default\_deny) | If network policies should by default deny cross namespace traffic | `bool` | `true` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name   = string<br>      labels = map(string)<br>      flux = object({<br>        enabled     = bool<br>        create_crds = bool<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>        github = object({<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_opa_gatekeeper_config"></a> [opa\_gatekeeper\_config](#input\_opa\_gatekeeper\_config) | Configuration for OPA Gatekeeper | <pre>object({<br>    additional_excluded_namespaces = list(string)<br>    enable_default_constraints     = bool<br>    additional_constraints = list(object({<br>      excluded_namespaces = list(string)<br>      processes           = list(string)<br>    }))<br>    enable_default_assigns = bool<br>    additional_assigns = list(object({<br>      name = string<br>    }))<br>  })</pre> | <pre>{<br>  "additional_assigns": [],<br>  "additional_constraints": [],<br>  "additional_excluded_namespaces": [],<br>  "enable_default_assigns": true,<br>  "enable_default_constraints": true<br>}</pre> | no |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| <a name="input_prometheus_config"></a> [prometheus\_config](#input\_prometheus\_config) | Configuration for prometheus | <pre>object({<br>    role_arn = string<br><br>    tenant_id = string<br><br>    remote_write_authenticated = bool<br>    remote_write_url           = string<br><br>    volume_claim_size = string<br><br>    resource_selector  = list(string)<br>    namespace_selector = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Should prometheus be enabled | `bool` | `true` | no |
| <a name="input_promtail_config"></a> [promtail\_config](#input\_promtail\_config) | Configuration for promtail | <pre>object({<br>    role_arn            = string<br>    loki_address        = string<br>    excluded_namespaces = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_promtail_enabled"></a> [promtail\_enabled](#input\_promtail\_enabled) | Should promtail be enabled | `bool` | `false` | no |
| <a name="input_reloader_enabled"></a> [reloader\_enabled](#input\_reloader\_enabled) | Should Reloader be enabled | `bool` | `true` | no |
| <a name="input_starboard_config"></a> [starboard\_config](#input\_starboard\_config) | Configuration for starboard & trivy | <pre>object({<br>    starboard_role_arn = string<br>    trivy_role_arn     = string<br>  })</pre> | n/a | yes |
| <a name="input_starboard_enabled"></a> [starboard\_enabled](#input\_starboard\_enabled) | Should Starboard be enabled | `bool` | `false` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Velero configuration | <pre>object({<br>    role_arn     = string<br>    s3_bucket_id = string<br>  })</pre> | n/a | yes |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Should Velero be enabled | `bool` | `false` | no |
| <a name="input_vpa_enabled"></a> [vpa\_enabled](#input\_vpa\_enabled) | Should VPA be enabled | `bool` | `true` | no |

## Outputs

No outputs.
