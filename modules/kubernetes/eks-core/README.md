# EKS Core

This module is used to configure EKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.48.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.2.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.12.1 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.11.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.48.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../kubernetes/azad-kube-proxy | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../../kubernetes/cert-manager | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../kubernetes/external-dns | n/a |
| <a name="module_ingress_healthz"></a> [ingress\_healthz](#module\_ingress\_healthz) | ../../kubernetes/ingress-healthz | n/a |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | ../../kubernetes/ingress-nginx | n/a |
| <a name="module_linkerd"></a> [linkerd](#module\_linkerd) | ../../kubernetes/linkerd | n/a |
| <a name="module_opa_gatekeeper"></a> [opa\_gatekeeper](#module\_opa\_gatekeeper) | ../../kubernetes/opa-gatekeeper | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ../../kubernetes/velero | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.aks_core_extras](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [kubernetes_cluster_role.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.list_namespaces](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.cluster_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.cluster_view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_list_ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.service_accounts](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/namespace) | resource |
| [kubernetes_namespace.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/namespace) | resource |
| [kubernetes_network_policy.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/network_policy) | resource |
| [kubernetes_role_binding.custom_resource_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.sa_edit](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.sa_helm_release](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.view](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/role_binding) | resource |
| [kubernetes_service_account.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/service_account) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/3.48.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for aad groups | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | The azad-kube-proxy configuration | <pre>object({<br>    fqdn                  = string<br>    dashboard             = string<br>    azure_ad_group_prefix = string<br>    allowed_ips           = list(string)<br>    azure_ad_app = object({<br>      client_id     = string<br>      client_secret = string<br>      tenant_id     = string<br>    })<br>    k8dash_config = object({<br>      client_id     = string<br>      client_secret = string<br>      scope         = string<br>    })<br>  })</pre> | <pre>{<br>  "allowed_ips": [],<br>  "azure_ad_app": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "tenant_id": ""<br>  },<br>  "azure_ad_group_prefix": "",<br>  "dashboard": "",<br>  "fqdn": "",<br>  "k8dash_config": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "scope": ""<br>  }<br>}</pre> | no |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_cert_manager_config"></a> [cert\_manager\_config](#input\_cert\_manager\_config) | Cert Manager configuration | <pre>object({<br>    notification_email = string<br>    dns_zone           = string<br>    role_arn           = string<br>  })</pre> | n/a | yes |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Should Cert Manager be enabled | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_external_dns_config"></a> [external\_dns\_config](#input\_external\_dns\_config) | External DNS configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Should External DNS be enabled | `bool` | `true` | no |
| <a name="input_ingress_healthz_enabled"></a> [ingress\_healthz\_enabled](#input\_ingress\_healthz\_enabled) | Should ingress-healthz be enabled | `bool` | `true` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Should Ingress NGINX be enabled | `bool` | `true` | no |
| <a name="input_kubernetes_network_policy_default_deny"></a> [kubernetes\_network\_policy\_default\_deny](#input\_kubernetes\_network\_policy\_default\_deny) | If network policies should by default deny cross namespace traffic | `bool` | `false` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name   = string<br>      labels = map(string)<br>      flux = object({<br>        enabled = bool<br>        github = object({<br>          repo = string<br>        })<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Velero configuration | <pre>object({<br>    role_arn     = string<br>    s3_bucket_id = string<br>  })</pre> | n/a | yes |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Should Velero be enabled | `bool` | `false` | no |

## Outputs

No outputs.
