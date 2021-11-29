# Azure Kubernetes Service - Global

This module is used to create resources that are used by AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.82.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 1.6.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.82.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.helm_operator](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/application) | resource |
| [azuread_application_password.helm_operator](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/application_password) | resource |
| [azuread_group.aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group) | resource |
| [azuread_group.cluster_admin](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group) | resource |
| [azuread_group.cluster_view](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group) | resource |
| [azuread_group.edit](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group) | resource |
| [azuread_group.view](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group) | resource |
| [azuread_group_member.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group_member) | resource |
| [azuread_group_member.helm_operator](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group_member) | resource |
| [azuread_group_member.resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group_member) | resource |
| [azuread_group_member.resource_group_owner](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group_member) | resource |
| [azuread_group_member.resource_group_reader](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/group_member) | resource |
| [azuread_service_principal.helm_operator](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/service_principal) | resource |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/container_registry) | resource |
| [azurerm_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/dns_zone) | resource |
| [azurerm_key_vault_access_policy.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.ssh_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/key_vault_secret) | resource |
| [azurerm_public_ip_prefix.aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/public_ip_prefix) | resource |
| [azurerm_role_assignment.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.acr_push](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.acr_reader](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_msi](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_dns_rg_read](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.external_storage_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.velero_msi](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.velero_rg_read](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.velero](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/storage_account) | resource |
| [azurerm_storage_container.velero](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.external_dns](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.velero](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/resources/user_assigned_identity) | resource |
| [random_password.helm_operator](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [azuread_group.acr_pull](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_group.acr_push](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_group.acr_reader](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_group.resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_group.resource_group_owner](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_group.resource_group_reader](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.core](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.82.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_authorized_ips"></a> [aks\_authorized\_ips](#input\_aks\_authorized\_ips) | Authorized IPs to access AKS API | `list(string)` | n/a | yes |
| <a name="input_aks_group_name_prefix"></a> [aks\_group\_name\_prefix](#input\_aks\_group\_name\_prefix) | Prefix for AKS Azure AD groups | `string` | `"aks"` | no |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groups | `string` | `"az"` | no |
| <a name="input_core_name"></a> [core\_name](#input\_core\_name) | The name for the core infrastructure | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | The DNS Zone to create | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes | <pre>list(<br>    object({<br>      name                    = string<br>      delegate_resource_group = bool<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_public_ip_prefix_configuration"></a> [public\_ip\_prefix\_configuration](#input\_public\_ip\_prefix\_configuration) | Configuration for public IP prefix | <pre>object({<br>    count         = number<br>    prefix_length = number<br>  })</pre> | <pre>{<br>  "count": 2,<br>  "prefix_length": 30<br>}</pre> | no |
| <a name="input_service_principal_name_prefix"></a> [service\_principal\_name\_prefix](#input\_service\_principal\_name\_prefix) | Prefix for service principals | `string` | `"sp"` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aad_groups"></a> [aad\_groups](#output\_aad\_groups) | Azure AD groups |
| <a name="output_aad_pod_identity"></a> [aad\_pod\_identity](#output\_aad\_pod\_identity) | aad-pod-identity user assigned identities |
| <a name="output_acr_name"></a> [acr\_name](#output\_acr\_name) | Azure Container Registry Name |
| <a name="output_aks_authorized_ips"></a> [aks\_authorized\_ips](#output\_aks\_authorized\_ips) | IP addresses authorized for API communication to Azure Kubernetes Service |
| <a name="output_aks_public_ip_prefix_ids"></a> [aks\_public\_ip\_prefix\_ids](#output\_aks\_public\_ip\_prefix\_ids) | Azure Kubernetes Service IP Prefixes |
| <a name="output_dns_zone"></a> [dns\_zone](#output\_dns\_zone) | DNS Zone to be used with external-dns |
| <a name="output_external_dns_identity"></a> [external\_dns\_identity](#output\_external\_dns\_identity) | MSI authentication identity for External DNS |
| <a name="output_helm_operator_credentials"></a> [helm\_operator\_credentials](#output\_helm\_operator\_credentials) | Credentials meant to be used by Helm Operator |
| <a name="output_namespaces"></a> [namespaces](#output\_namespaces) | Kubernetes namespaces |
| <a name="output_ssh_public_key"></a> [ssh\_public\_key](#output\_ssh\_public\_key) | SSH public key to add to servers |
| <a name="output_velero"></a> [velero](#output\_velero) | Velero configuration |
| <a name="output_xenit"></a> [xenit](#output\_xenit) | Configuration used by monitoring solution to get authentication credentials |
