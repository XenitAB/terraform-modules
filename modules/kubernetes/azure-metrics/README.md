# azure-metrics (azure-metrics)

This module is used to query azure for metrics that we use to monitor our AKS clusters.
We are using: https://github.com/webdevops/azure-metrics-exporter to gather the metrics.

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
| [git_repository_file.azure_metrics](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The client\_id for aadpodidentity with access to AZ specific metrics | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_podmonitor_kubernetes"></a> [podmonitor\_kubernetes](#input\_podmonitor\_kubernetes) | Enable podmonitor for kubernetes? | `bool` | `true` | no |
| <a name="input_podmonitor_loadbalancer"></a> [podmonitor\_loadbalancer](#input\_podmonitor\_loadbalancer) | Enable podmonitor for loadbalancers? | `bool` | `true` | no |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | The resource\_id for aadpodidentity to the resource | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription id where your kubernetes cluster is deployed | `string` | n/a | yes |

## Outputs

No outputs.
