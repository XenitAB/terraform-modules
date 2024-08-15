# Azure Kubernetes Service - Global

This module is used to create resources that are used by AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.107.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.107.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../azure-ad/azad-kube-proxy | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_group_member.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azurerm_eventhub.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/eventhub_namespace) | resource |
| [azurerm_eventhub_namespace_authorization_rule.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/eventhub_namespace_authorization_rule) | resource |
| [azurerm_eventhub_namespace_authorization_rule.listen](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/eventhub_namespace_authorization_rule) | resource |
| [azurerm_key_vault_access_policy.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.azad_kube_proxy](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.eventhub_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ssh_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/key_vault_secret) | resource |
| [azurerm_public_ip_prefix.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/public_ip_prefix) | resource |
| [azurerm_role_assignment.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/resources/user_assigned_identity) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/private_key) | resource |
| [azuread_group.resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.core](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.log](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/data-sources/resource_group) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.107.0/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_authorized_ips"></a> [aks\_authorized\_ips](#input\_aks\_authorized\_ips) | Authorized IPs to access AKS API | `list(string)` | n/a | yes |
| <a name="input_aks_managed_identity"></a> [aks\_managed\_identity](#input\_aks\_managed\_identity) | AKS Azure AD managed identity | `string` | n/a | yes |
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | Azure AD Kubernetes Proxy configuration | <pre>object({<br>    cluster_name_prefix = string<br>    proxy_url_override  = string<br>  })</pre> | <pre>{<br>  "cluster_name_prefix": "aks",<br>  "proxy_url_override": ""<br>}</pre> | no |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groups | `string` | `"az"` | no |
| <a name="input_core_name"></a> [core\_name](#input\_core\_name) | The name for the core infrastructure | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | List of DNS Zone to create | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes | <pre>list(<br>    object({<br>      name = string<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_public_ip_prefix_configuration"></a> [public\_ip\_prefix\_configuration](#input\_public\_ip\_prefix\_configuration) | Configuration for public IP prefix | <pre>object({<br>    count         = number<br>    prefix_length = number<br>  })</pre> | <pre>{<br>  "count": 2,<br>  "prefix_length": 30<br>}</pre> | no |
| <a name="input_public_ip_prefix_name_override"></a> [public\_ip\_prefix\_name\_override](#input\_public\_ip\_prefix\_name\_override) | Override the default public ip prefix name - the last digit | `string` | `""` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aad_pod_identity"></a> [aad\_pod\_identity](#output\_aad\_pod\_identity) | aad-pod-identity user assigned identities |
| <a name="output_aks_authorized_ips"></a> [aks\_authorized\_ips](#output\_aks\_authorized\_ips) | IP addresses authorized for API communication to Azure Kubernetes Service |
| <a name="output_aks_managed_identity_group_id"></a> [aks\_managed\_identity\_group\_id](#output\_aks\_managed\_identity\_group\_id) | The group id of aks managed identity |
| <a name="output_aks_public_ip_prefix_ids"></a> [aks\_public\_ip\_prefix\_ids](#output\_aks\_public\_ip\_prefix\_ids) | Azure Kubernetes Service IP Prefixes |
| <a name="output_azad_kube_proxy"></a> [azad\_kube\_proxy](#output\_azad\_kube\_proxy) | The Azure AD Application config for azad-kube-proxy |
| <a name="output_dns_zone"></a> [dns\_zone](#output\_dns\_zone) | DNS Zone to be used with external-dns |
| <a name="output_log_eventhub_authorization_rule_id"></a> [log\_eventhub\_authorization\_rule\_id](#output\_log\_eventhub\_authorization\_rule\_id) | The authoritzation rule id for event hub |
| <a name="output_log_eventhub_hostname"></a> [log\_eventhub\_hostname](#output\_log\_eventhub\_hostname) | The eventhub hostname for k8s logs |
| <a name="output_log_eventhub_name"></a> [log\_eventhub\_name](#output\_log\_eventhub\_name) | The eventhub name for k8s logs |
| <a name="output_namespaces"></a> [namespaces](#output\_namespaces) | Kubernetes namespaces |
| <a name="output_ssh_public_key"></a> [ssh\_public\_key](#output\_ssh\_public\_key) | SSH public key to add to servers |
| <a name="output_xenit"></a> [xenit](#output\_xenit) | Configuration used by monitoring solution to get authentication credentials |
