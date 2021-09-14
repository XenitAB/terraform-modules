# Ingress NGINX (ingress-nginx)

This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.ingress_nginx_extras](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.ingress_nginx_private](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.ingress_nginx_public](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider used for load balancer | `string` | n/a | yes |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Should datadog be enabled | `bool` | `false` | no |
| <a name="input_default_certificate"></a> [default\_certificate](#input\_default\_certificate) | If enalbed and configured nginx will be configured with a default certificate. | <pre>object({<br>    enabled  = bool,<br>    dns_zone = string,<br>  })</pre> | <pre>{<br>  "dns_zone": "",<br>  "enabled": false<br>}</pre> | no |
| <a name="input_extra_config"></a> [extra\_config](#input\_extra\_config) | Extra config to add to Ingress NGINX | `map(string)` | `{}` | no |
| <a name="input_extra_headers"></a> [extra\_headers](#input\_extra\_headers) | Addtional headers to be added | `map(string)` | `{}` | no |
| <a name="input_http_snippet"></a> [http\_snippet](#input\_http\_snippet) | Configure helm ingress http-snippet | `string` | `""` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_public_private_enabled"></a> [public\_private\_enabled](#input\_public\_private\_enabled) | Should ingress controllers for both public and private be created? | `bool` | `false` | no |

## Outputs

No outputs.
