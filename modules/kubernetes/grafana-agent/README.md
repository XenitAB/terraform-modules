# Grafana agent operator

Adds [`grafana-agent`](https://grafana.com/docs/agent/latest/) (the operator) amd
[`kube-state-metrics`](https://github.com/kubernetes/kube-state-metrics) to a Kubernetes clusters.

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
| [git_repository_file.grafana_agent](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.grafana_agent_extras](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kube_state_metrics](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [kubernetes_secret.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | the cluster name | `string` | n/a | yes |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | grafana-agent credentials | <pre>object({<br/>    metrics_username = string<br/>    metrics_password = string<br/>    logs_username    = string<br/>    logs_password    = string<br/>    traces_username  = string<br/>    traces_password  = string<br/>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | the name of the environment | `string` | n/a | yes |
| <a name="input_extra_namespaces"></a> [extra\_namespaces](#input\_extra\_namespaces) | List of namespaces that should be enabled | `list(string)` | <pre>[<br/>  "ingress-nginx"<br/>]</pre> | no |
| <a name="input_include_kubelet_metrics"></a> [include\_kubelet\_metrics](#input\_include\_kubelet\_metrics) | If kubelet metrics shall be included for the namespaces in 'namespace\_include' | `bool` | `false` | no |
| <a name="input_namespace_include"></a> [namespace\_include](#input\_namespace\_include) | A list of the namespaces that kube-state-metrics and kubelet metrics | `list(string)` | n/a | yes |
| <a name="input_remote_write_urls"></a> [remote\_write\_urls](#input\_remote\_write\_urls) | the remote write urls | <pre>object({<br/>    metrics = string<br/>    logs    = string<br/>    traces  = string<br/>  })</pre> | <pre>{<br/>  "logs": "",<br/>  "metrics": "",<br/>  "traces": ""<br/>}</pre> | no |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
