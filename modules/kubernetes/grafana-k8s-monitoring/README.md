# grafana-k8s-monitoring

Adds [grafana-k8s-monitoring](https://github.com/grafana/k8s-monitoring-helm/tree/main/charts/k8s-monitoring) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.107.0 |
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
| [git_repository_file.grafana_k8s_monitoring](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Unique identifier of the cluster across instances. | `string` | n/a | yes |
| <a name="input_grafana_cloud_api_key"></a> [grafana\_cloud\_api\_key](#input\_grafana\_cloud\_api\_key) | API key for connecting to grafana cloud. | `string` | n/a | yes |
| <a name="input_grafana_k8s_monitor_config"></a> [grafana\_k8s\_monitor\_config](#input\_grafana\_k8s\_monitor\_config) | Configuration for the username and password | <pre>object({<br>    grafana_cloud_prometheus_username = string<br>    grafana_cloud_prometheus_host     = string<br>    grafana_cloud_loki_host           = string<br>    grafana_cloud_loki_username       = string<br>    grafana_cloud_tempo_host          = string<br>    grafana_cloud_tempo_username      = string<br>  })</pre> | <pre>{<br>  "grafana_cloud_loki_host": "",<br>  "grafana_cloud_loki_username": "",<br>  "grafana_cloud_prometheus_host": "",<br>  "grafana_cloud_prometheus_username": "",<br>  "grafana_cloud_tempo_host": "",<br>  "grafana_cloud_tempo_username": ""<br>}</pre> | no |

## Outputs

No outputs.
