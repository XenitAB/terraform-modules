# Ingress NGINX (ingress-nginx)

This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [helm_release.ingress_nginx_extras](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [helm_release.ingress_nginx_private](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [helm_release.ingress_nginx_public](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider used for load balancer | `string` | n/a | yes |
| <a name="input_customization"></a> [customization](#input\_customization) | Global customization that will be applied to all ingress controllers. | <pre>object({<br>    allow_snippet_annotations = bool<br>    http_snippet              = string<br>    extra_config              = map(string)<br>    extra_headers             = map(string)<br>  })</pre> | <pre>{<br>  "allow_snippet_annotations": false,<br>  "extra_config": {},<br>  "extra_headers": {},<br>  "http_snippet": ""<br>}</pre> | no |
| <a name="input_customization_private"></a> [customization\_private](#input\_customization\_private) | Private specific customization, will override the global customization. | <pre>object({<br>    allow_snippet_annotations = optional(bool)<br>    http_snippet              = optional(string)<br>    extra_config              = optional(map(string))<br>    extra_headers             = optional(map(string))<br>  })</pre> | `{}` | no |
| <a name="input_customization_public"></a> [customization\_public](#input\_customization\_public) | Public specific customization, will override the global customization. | <pre>object({<br>    allow_snippet_annotations = optional(bool)<br>    http_snippet              = optional(string)<br>    extra_config              = optional(map(string))<br>    extra_headers             = optional(map(string))<br>  })</pre> | `{}` | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Should datadog be enabled | `bool` | `false` | no |
| <a name="input_default_certificate"></a> [default\_certificate](#input\_default\_certificate) | If enalbed and configured nginx will be configured with a default certificate. | <pre>object({<br>    enabled  = bool,<br>    dns_zone = string,<br>  })</pre> | <pre>{<br>  "dns_zone": "",<br>  "enabled": false<br>}</pre> | no |
| <a name="input_external_dns_hostname"></a> [external\_dns\_hostname](#input\_external\_dns\_hostname) | Hostname for external-dns to use | `string` | `""` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_public_private_enabled"></a> [public\_private\_enabled](#input\_public\_private\_enabled) | If true will create a public and private ingress controller. Otherwise only a public ingress controller will be created. | `bool` | `false` | no |

## Outputs

No outputs.
