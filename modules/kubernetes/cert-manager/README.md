# Certificate manager (cert-manager)

This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.

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
| [azurerm_federated_identity_credential.cert_manager](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.cert_manager_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.cert_manager](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.cert_manager](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acme_server"></a> [acme\_server](#input\_acme\_server) | ACME server to add to the created ClusterIssuer | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | Map of DNS zones with id | `map(string)` | n/a | yes |
| <a name="input_gateway_api_config"></a> [gateway\_api\_config](#input\_gateway\_api\_config) | The Gateway API configuration | <pre>object({<br/>    gateway_name      = optional(string, "")<br/>    gateway_namespace = optional(string, "")<br/>  })</pre> | `{}` | no |
| <a name="input_gateway_api_enabled"></a> [gateway\_api\_enabled](#input\_gateway\_api\_enabled) | If Gateway API should be enabled | `bool` | n/a | yes |
| <a name="input_global_resource_group_name"></a> [global\_resource\_group\_name](#input\_global\_resource\_group\_name) | The Azure global resource group name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address to send certificate expiration notifications | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription id | `string` | n/a | yes |

## Outputs

No outputs.
