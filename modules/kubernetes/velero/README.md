# Velero

This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.110.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.110.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.velero](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.external_storage_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.velero_msi](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.velero_rg_read](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.velero](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/resources/storage_account) | resource |
| [azurerm_storage_container.velero](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.velero](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.velero](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.velero_extras](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.110.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_managed_identity"></a> [aks\_managed\_identity](#input\_aks\_managed\_identity) | AKS Azure AD managed identity | `string` | n/a | yes |
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br/>    storage_account_name      = string,<br/>    storage_account_container = string<br/>  })</pre> | <pre>{<br/>  "storage_account_container": "",<br/>  "storage_account_name": ""<br/>}</pre> | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription id | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_velero"></a> [velero](#output\_velero) | Velero configuration |
