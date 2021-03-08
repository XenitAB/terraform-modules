# Azure AD Kubernetes API Proxy

Adds [`azad-kube-proxy`](https://github.com/XenitAB/azad-kube-proxy) to a Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/2.0.2/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.2/docs/resources/namespace) |
| [kubernetes_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.2/docs/resources/secret) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_ips | The external IPs allowed through the ingress to azad-kube-proxy | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| azure\_ad\_app | The Azure AD Application config for azad-kube-proxy | <pre>object({<br>    client_id     = string<br>    client_secret = string<br>    tenant_id     = string<br>  })</pre> | n/a | yes |
| dashboard | What dashboard to use with azad-kube-proxy | `string` | `"k8dash"` | no |
| fqdn | The name to use with the ingress (fully qualified domain name). Example: k8s.example.com | `string` | n/a | yes |
| k8dash\_config | The k8dash configuration if chosen as dashboard | <pre>object({<br>    client_id     = string<br>    client_secret = string<br>    scope         = string<br>  })</pre> | <pre>{<br>  "client_id": "",<br>  "client_secret": "",<br>  "scope": ""<br>}</pre> | no |

## Outputs

No output.
