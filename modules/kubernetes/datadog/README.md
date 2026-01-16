# Datadog

Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.
This module is built to only gather application data.
API vs APP key.
API is used to send metrics to datadog from the agents.
APP key is used to be able to manage configuration inside datadog like alarms.
https://docs.datadoghq.com/account_management/api-app-keys/

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.57.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.57.0 |
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.datadog](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault_access_policy.datadog](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_user_assigned_identity.datadog](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.azure_config](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.datadog_app](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.datadog_chart](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.datadog_extras](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.datadog_manifests](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.datadog_operator](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.datadog_values](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apm_ignore_resources"></a> [apm\_ignore\_resources](#input\_apm\_ignore\_resources) | The resources that shall be excluded from APM | `list(string)` | n/a | yes |
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br/>    azure_key_vault_name = string<br/>  })</pre> | <pre>{<br/>  "azure_key_vault_name": ""<br/>}</pre> | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | Site to connect Datadog agent | `string` | `"datadoghq.eu"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Core key vault id | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_namespace_include"></a> [namespace\_include](#input\_namespace\_include) | The namespace that should be checked by Datadog, example: kube\_namespace:NAMESPACE kube\_namespace:NAMESPACE2 | `list(string)` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
