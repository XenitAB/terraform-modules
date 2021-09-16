# EKS Core

This module is used to configure EKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.58.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.3.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.14.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.11.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.4.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.58.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../kubernetes/azad-kube-proxy | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../../kubernetes/cert-manager | n/a |
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | ../../kubernetes/cluster-autoscaler | n/a |
| <a name="module_csi_secrets_store_provider_aws"></a> [csi\_secrets\_store\_provider\_aws](#module\_csi\_secrets\_store\_provider\_aws) | ../../kubernetes/csi-secrets-store-provider-aws | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../kubernetes/external-dns | n/a |
| <a name="module_falco"></a> [falco](#module\_falco) | ../../kubernetes/falco | n/a |
| <a name="module_fluxcd_v2_azure_devops"></a> [fluxcd\_v2\_azure\_devops](#module\_fluxcd\_v2\_azure\_devops) | ../../kubernetes/fluxcd-v2-azdo | n/a |
| <a name="module_fluxcd_v2_github"></a> [fluxcd\_v2\_github](#module\_fluxcd\_v2\_github) | ../../kubernetes/fluxcd-v2-github | n/a |
| <a name="module_goldpinger"></a> [goldpinger](#module\_goldpinger) | ../../kubernetes/goldpinger | n/a |
| <a name="module_ingress_healthz"></a> [ingress\_healthz](#module\_ingress\_healthz) | ../../kubernetes/ingress-healthz | n/a |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | ../../kubernetes/ingress-nginx | n/a |
| <a name="module_linkerd"></a> [linkerd](#module\_linkerd) | ../../kubernetes/linkerd | n/a |
| <a name="module_opa_gatekeeper"></a> [opa\_gatekeeper](#module\_opa\_gatekeeper) | ../../kubernetes/opa-gatekeeper | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ../../kubernetes/prometheus | n/a |
| <a name="module_reloader"></a> [reloader](#module\_reloader) | ../../kubernetes/reloader | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ../../kubernetes/velero | n/a |
| <a name="module_xenit"></a> [xenit](#module\_xenit) | ../../kubernetes/xenit | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.aks_core_extras](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_cluster_role.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.list_namespaces](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.cluster_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.cluster_view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.service_accounts](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_network_policy.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/network_policy) | resource |
| [kubernetes_role_binding.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.sa_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.sa_helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/role_binding) | resource |
| [kubernetes_service_account.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/service_account) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.58.0/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/3.58.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for aad groups | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | The azad-kube-proxy configuration | <pre>object({<br>    fqdn                  = string<br>    dashboard             = string<br>    azure_ad_group_prefix = string<br>    allowed_ips           = list(string)<br>    azure_ad_app = object({<br>      client_id     = string<br>      client_secret = string<br>      tenant_id     = string<br>    })<br>    k8dash_config = object({<br>      client_id     = string<br>      client_secret = string<br>      scope         = string<br>    })<br>  })</pre> | <pre>{<br>  "allowed_ips": [],<br>  "azure_ad_app": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "tenant_id": ""<br>  },<br>  "azure_ad_group_prefix": "",<br>  "dashboard": "",<br>  "fqdn": "",<br>  "k8dash_config": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "scope": ""<br>  }<br>}</pre> | no |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_cert_manager_config"></a> [cert\_manager\_config](#input\_cert\_manager\_config) | Cert Manager configuration | <pre>object({<br>    notification_email = string<br>    dns_zone           = string<br>    role_arn           = string<br>  })</pre> | n/a | yes |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Should Cert Manager be enabled | `bool` | `true` | no |
| <a name="input_cluster_autoscaler_config"></a> [cluster\_autoscaler\_config](#input\_cluster\_autoscaler\_config) | Cluster Autoscaler configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_cluster_autoscaler_enabled"></a> [cluster\_autoscaler\_enabled](#input\_cluster\_autoscaler\_enabled) | Should Cluster Autoscaler be enabled | `bool` | `true` | no |
| <a name="input_csi_secrets_store_provider_aws_enabled"></a> [csi\_secrets\_store\_provider\_aws\_enabled](#input\_csi\_secrets\_store\_provider\_aws\_enabled) | Should csi-secrets-store-provider-aws be enabled | `bool` | `true` | no |
| <a name="input_eks_name_suffix"></a> [eks\_name\_suffix](#input\_eks\_name\_suffix) | The suffix for the eks clusters | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_external_dns_config"></a> [external\_dns\_config](#input\_external\_dns\_config) | External DNS configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Should External DNS be enabled | `bool` | `true` | no |
| <a name="input_falco_enabled"></a> [falco\_enabled](#input\_falco\_enabled) | Should Falco be enabled | `bool` | `false` | no |
| <a name="input_flux_system_enabled"></a> [flux\_system\_enabled](#input\_flux\_system\_enabled) | Should flux-system be enabled | `bool` | `true` | no |
| <a name="input_fluxcd_v2_config"></a> [fluxcd\_v2\_config](#input\_fluxcd\_v2\_config) | Configuration for fluxcd-v2 | <pre>object({<br>    type = string<br>    github = object({<br>      owner = string<br>    })<br>    azure_devops = object({<br>      pat  = string<br>      org  = string<br>      proj = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_fluxcd_v2_enabled"></a> [fluxcd\_v2\_enabled](#input\_fluxcd\_v2\_enabled) | Should fluxcd-v2 be enabled | `bool` | `true` | no |
| <a name="input_goldpinger_enabled"></a> [goldpinger\_enabled](#input\_goldpinger\_enabled) | Should goldpinger be enabled | `bool` | `true` | no |
| <a name="input_ingress_config"></a> [ingress\_config](#input\_ingress\_config) | Ingress configuration | <pre>object({<br>    http_snippet           = string<br>    public_private_enabled = bool<br>  })</pre> | <pre>{<br>  "http_snippet": "",<br>  "public_private_enabled": false<br>}</pre> | no |
| <a name="input_ingress_healthz_enabled"></a> [ingress\_healthz\_enabled](#input\_ingress\_healthz\_enabled) | Should ingress-healthz be enabled | `bool` | `true` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Should Ingress NGINX be enabled | `bool` | `true` | no |
| <a name="input_kubernetes_network_policy_default_deny"></a> [kubernetes\_network\_policy\_default\_deny](#input\_kubernetes\_network\_policy\_default\_deny) | If network policies should by default deny cross namespace traffic | `bool` | `false` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name   = string<br>      labels = map(string)<br>      flux = object({<br>        enabled     = bool<br>        create_crds = bool<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>        github = object({<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_opa_gatekeeper_config"></a> [opa\_gatekeeper\_config](#input\_opa\_gatekeeper\_config) | Configuration for OPA Gatekeeper | <pre>object({<br>    additional_excluded_namespaces = list(string)<br>    enable_default_constraints     = bool<br>    additional_constraints = list(object({<br>      excluded_namespaces = list(string)<br>      processes           = list(string)<br>    }))<br>    enable_default_assigns = bool<br>    additional_assigns = list(object({<br>      name = string<br>    }))<br>  })</pre> | <pre>{<br>  "additional_assigns": [],<br>  "additional_constraints": [],<br>  "additional_excluded_namespaces": [],<br>  "enable_default_assigns": true,<br>  "enable_default_constraints": true<br>}</pre> | no |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| <a name="input_prometheus_config"></a> [prometheus\_config](#input\_prometheus\_config) | Configuration for prometheus | <pre>object({<br>    remote_write_enabled = bool<br>    remote_write_url     = string<br>    tenant_id            = string<br><br>    volume_claim_enabled            = bool<br>    volume_claim_storage_class_name = string<br>    volume_claim_size               = string<br><br>    alertmanager_enabled = bool<br><br>    resource_selector  = list(string)<br>    namespace_selector = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Should prometheus be enabled | `bool` | `true` | no |
| <a name="input_reloader_enabled"></a> [reloader\_enabled](#input\_reloader\_enabled) | Should Reloader be enabled | `bool` | `true` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Velero configuration | <pre>object({<br>    role_arn     = string<br>    s3_bucket_id = string<br>  })</pre> | n/a | yes |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Should Velero be enabled | `bool` | `false` | no |
| <a name="input_xenit_config"></a> [xenit\_config](#input\_xenit\_config) | Xenit Platform configuration | <pre>object({<br>    role_arn        = string<br>    thanos_receiver = string<br>    loki_api        = string<br>  })</pre> | <pre>{<br>  "loki_api": "",<br>  "role_arn": "",<br>  "thanos_receiver": ""<br>}</pre> | no |
| <a name="input_xenit_enabled"></a> [xenit\_enabled](#input\_xenit\_enabled) | Should Platform be enabled | `bool` | `false` | no |

## Outputs

No outputs.
