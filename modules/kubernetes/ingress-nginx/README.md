# Ingress NGINX (ingress-nginx)

This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.ingress_nginx](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.ingress_nginx_private](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.namespace](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_customization"></a> [customization](#input\_customization) | Global customization that will be applied to all ingress controllers. | <pre>object({<br/>    allow_snippet_annotations = bool<br/>    http_snippet              = string<br/>    extra_config              = map(string)<br/>    extra_headers             = map(string)<br/>  })</pre> | <pre>{<br/>  "allow_snippet_annotations": false,<br/>  "extra_config": {},<br/>  "extra_headers": {},<br/>  "http_snippet": ""<br/>}</pre> | no |
| <a name="input_customization_private"></a> [customization\_private](#input\_customization\_private) | Private specific customization, will override the global customization. | <pre>object({<br/>    allow_snippet_annotations = optional(bool)<br/>    http_snippet              = optional(string)<br/>    extra_config              = optional(map(string))<br/>    extra_headers             = optional(map(string))<br/>  })</pre> | `{}` | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Should datadog be enabled | `bool` | `false` | no |
| <a name="input_default_certificate"></a> [default\_certificate](#input\_default\_certificate) | If enalbed and configured nginx will be configured with a default certificate. | <pre>object({<br/>    enabled  = bool,<br/>    dns_zone = string,<br/>  })</pre> | <pre>{<br/>  "dns_zone": "",<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_external_dns_hostname"></a> [external\_dns\_hostname](#input\_external\_dns\_hostname) | Hostname for external-dns to use | `string` | `""` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_private_ingress_enabled"></a> [private\_ingress\_enabled](#input\_private\_ingress\_enabled) | If true will create a private ingress controller. Otherwise only a public ingress controller will be created. | `bool` | `false` | no |

## Outputs

No outputs.
