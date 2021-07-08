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
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../kubernetes/azad-kube-proxy | n/a |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | ../../kubernetes/ingress-nginx | n/a |
| <a name="module_opa_gatekeeper"></a> [opa\_gatekeeper](#module\_opa\_gatekeeper) | ../../kubernetes/opa-gatekeeper | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.aks_core_extras](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [kubernetes_namespace.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/namespace) | resource |
| [kubernetes_network_policy.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.2/docs/resources/network_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | The azad-kube-proxy configuration | <pre>object({<br>    fqdn                  = string<br>    dashboard             = string<br>    azure_ad_group_prefix = string<br>    allowed_ips           = list(string)<br>    azure_ad_app = object({<br>      client_id     = string<br>      client_secret = string<br>      tenant_id     = string<br>    })<br>    k8dash_config = object({<br>      client_id     = string<br>      client_secret = string<br>      scope         = string<br>    })<br>  })</pre> | <pre>{<br>  "allowed_ips": [],<br>  "azure_ad_app": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "tenant_id": ""<br>  },<br>  "azure_ad_group_prefix": "",<br>  "dashboard": "",<br>  "fqdn": "",<br>  "k8dash_config": {<br>    "client_id": "",<br>    "client_secret": "",<br>    "scope": ""<br>  }<br>}</pre> | no |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Should Ingress NGINX be enabled | `bool` | `true` | no |
| <a name="input_kubernetes_network_policy_default_deny"></a> [kubernetes\_network\_policy\_default\_deny](#input\_kubernetes\_network\_policy\_default\_deny) | If network policies should by default deny cross namespace traffic | `bool` | `false` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name   = string<br>      labels = map(string)<br>      flux = object({<br>        enabled = bool<br>        github = object({<br>          repo = string<br>        })<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `true` | no |

## Outputs

No outputs.
