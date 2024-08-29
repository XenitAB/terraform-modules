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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.107.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.grafana_k8s_monitor](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault_access_policy.grafana_k8s_monitor](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_user_assigned_identity.grafana_k8s_monitor](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.grafana_k8s_monitoring](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Unique identifier of the cluster across instances. | `string` | n/a | yes |
| <a name="input_grafana_k8s_monitor_config"></a> [grafana\_k8s\_monitor\_config](#input\_grafana\_k8s\_monitor\_config) | Configuration for the username and password | <pre>object({<br>    grafana_cloud_prometheus_host = string<br>    grafana_cloud_loki_host       = string<br>    grafana_cloud_tempo_host      = string<br>  })</pre> | <pre>{<br>  "grafana_cloud_loki_host": "",<br>  "grafana_cloud_prometheus_host": "",<br>  "grafana_cloud_tempo_host": ""<br>}</pre> | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Core key vault id | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |

## Outputs

No outputs.
