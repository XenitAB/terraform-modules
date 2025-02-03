# Ingress NGINX (ingress-nginx)

This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.ingress_nginx](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.ingress_nginx_private](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [kubernetes_cluster_role.logs_ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/cluster_role) | resource |
| [kubernetes_namespace.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [kubernetes_role_binding.logs_ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/role_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for Azure AD Groups (AAD Groups) | <pre>object({<br/>    view = map(any)<br/>    edit = map(any)<br/>    cluster_admin = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>    cluster_view = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>    aks_managed_identity = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_customization"></a> [customization](#input\_customization) | Global customization that will be applied to all ingress controllers. | <pre>object({<br/>    allow_snippet_annotations = bool<br/>    http_snippet              = string<br/>    extra_config              = map(string)<br/>    extra_headers             = map(string)<br/>  })</pre> | <pre>{<br/>  "allow_snippet_annotations": false,<br/>  "extra_config": {},<br/>  "extra_headers": {},<br/>  "http_snippet": ""<br/>}</pre> | no |
| <a name="input_customization_private"></a> [customization\_private](#input\_customization\_private) | Private specific customization, will override the global customization. | <pre>object({<br/>    allow_snippet_annotations = optional(bool)<br/>    http_snippet              = optional(string)<br/>    extra_config              = optional(map(string))<br/>    extra_headers             = optional(map(string))<br/>  })</pre> | `{}` | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Should datadog be enabled | `bool` | `false` | no |
| <a name="input_default_certificate"></a> [default\_certificate](#input\_default\_certificate) | If enalbed and configured nginx will be configured with a default certificate. | <pre>object({<br/>    enabled  = bool,<br/>    dns_zone = string,<br/>  })</pre> | <pre>{<br/>  "dns_zone": "",<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_external_dns_hostname"></a> [external\_dns\_hostname](#input\_external\_dns\_hostname) | Hostname for external-dns to use | `string` | `""` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | The desired number of minimum replicas | `number` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br/>    object({<br/>      name   = string<br/>      labels = map(string)<br/>      flux = optional(object({<br/>        provider            = string<br/>        project             = optional(string)<br/>        repository          = string<br/>        include_tenant_name = optional(bool, false)<br/>        create_crds         = optional(bool, false)<br/>      }))<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_private_ingress_enabled"></a> [private\_ingress\_enabled](#input\_private\_ingress\_enabled) | If true will create a private ingress controller. Otherwise only a public ingress controller will be created. | `bool` | `false` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The desired number of replicas | `number` | n/a | yes |

## Outputs

No outputs.
