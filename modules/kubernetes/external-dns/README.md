# External DNS (external-dns)

This module is used to add [`external-dns`](https://github.com/kubernetes-sigs/external-dns) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.107.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.107.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.external_dns](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.external_dns_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_reader](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.external_dns](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.external_dns](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [azurerm_resource_group.global](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_dns_provider"></a> [dns\_provider](#input\_dns\_provider) | DNS provider to use. | `string` | n/a | yes |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | Map of DNS zones with id | `map(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_global_resource_group_name"></a> [global\_resource\_group\_name](#input\_global\_resource\_group\_name) | The Azure global resource group name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_sources"></a> [sources](#input\_sources) | k8s resource types to observe | `list(string)` | <pre>[<br/>  "ingress",<br/>  "service"<br/>]</pre> | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription id | `string` | n/a | yes |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | The txt-owner-id for external-dns | `string` | n/a | yes |

## Outputs

No outputs.
