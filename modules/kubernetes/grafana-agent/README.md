## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.grafana_agent_extras](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.grafana_agent_operator](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/namespace) | resource |
| [kubernetes_secret.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | the cluster name | `string` | n/a | yes |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | grafana-agent credentials | <pre>object({<br>    metrics_username = string<br>    metrics_password = string<br>    logs_username    = string<br>    logs_password    = string<br>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | the name of the environment | `string` | n/a | yes |
| <a name="input_remote_write_urls"></a> [remote\_write\_urls](#input\_remote\_write\_urls) | the remote write urls | <pre>object({<br>    metrics = string<br>    logs    = string<br>  })</pre> | <pre>{<br>  "logs": "https://logs-prod-eu-west-0.grafana.net/loki/api/v1/push",<br>  "metrics": "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push"<br>}</pre> | no |

## Outputs

No outputs.
