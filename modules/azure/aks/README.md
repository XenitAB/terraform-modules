# Azure Kubernetes Service

This module is used to create AKS clusters.
The cluster is configured with a system pool that currently has a single node. The node is tainted
so that only kube-system pods can run on that system pool. This is partially to protect the system
critical pods from user applications and simplify scaling.
https://docs.microsoft.com/en-us/azure/aks/use-system-pools#system-and-user-node-pools

Refer to the following docs for steps to replace the system node pool without recreating the cluster.
https://pumpingco.de/blog/modify-aks-default-node-pool-in-terraform-without-redeploying-the-cluster/

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.7.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_automation"></a> [automation](#module\_automation) | ./automation | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_group_member.aks_cluster_identity](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azuread_group_member.tenant](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/group_member) | resource |
| [azurerm_federated_identity_credential.tenant](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_log_analytics_workspace.xks_audit](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_log_analytics_workspace.xks_op](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.log_analytics_workspace_audit](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.log_eventhub_audit](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.log_storage_account_audit](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_security_rule.additonal_security_rules](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_internet_azure_lb](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/network_security_rule) | resource |
| [azurerm_resource_policy_assignment.agentless_discovery](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/resource_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.kubernetes_sensor](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/resource_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.vulnerability_assessments](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/resource_policy_assignment) | resource |
| [azurerm_role_assignment.aks](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_managed_identity_noderg_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_managed_identity_noderg_virtual_machine_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cluster_admin](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cluster_view](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.edit](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.view](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_security_center_auto_provisioning.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/security_center_auto_provisioning) | resource |
| [azurerm_security_center_subscription_pricing.containers](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_storage_management_policy.log_storage_account_audit_policy](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/storage_management_policy) | resource |
| [azurerm_user_assigned_identity.aks](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.tenant](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/user_assigned_identity) | resource |
| [azuread_group.tenant_resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/public_ip) | data source |
| [azurerm_resource_group.aks](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.log](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/resource_group) | data source |
| [azurerm_resources.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/resources) | data source |
| [azurerm_storage_account.log](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_groups"></a> [aad\_groups](#input\_aad\_groups) | Configuration for Azure AD Groups (AAD Groups) | <pre>object({<br/>    view = map(any)<br/>    edit = map(any)<br/>    cluster_admin = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>    cluster_view = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>    aks_managed_identity = object({<br/>      id   = string<br/>      name = string<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_add_default_security_lb_rule"></a> [add\_default\_security\_lb\_rule](#input\_add\_default\_security\_lb\_rule) | Should default LB rule (allow internat to azure lb ips) be applied to NSG? | `bool` | `false` | no |
| <a name="input_additonal_security_rules"></a> [additonal\_security\_rules](#input\_additonal\_security\_rules) | Rules for trafic in the NSG associated to AKS | <pre>list(object({<br/>    name                       = string<br/>    priority                   = number<br/>    direction                  = string<br/>    access                     = string<br/>    protocol                   = string<br/>    source_port_range          = string<br/>    destination_port_range     = string<br/>    source_address_prefix      = string<br/>    destination_address_prefix = string<br/>  }))</pre> | `[]` | no |
| <a name="input_aks_audit_log_retention"></a> [aks\_audit\_log\_retention](#input\_aks\_audit\_log\_retention) | The aks audit log retention in days, 0 = infinite | `number` | `30` | no |
| <a name="input_aks_authorized_ips"></a> [aks\_authorized\_ips](#input\_aks\_authorized\_ips) | Authorized IPs to access AKS API | `list(string)` | n/a | yes |
| <a name="input_aks_automation_config"></a> [aks\_automation\_config](#input\_aks\_automation\_config) | AKS automation configuration | <pre>object({<br/>    public_network_access_enabled = optional(bool, false),<br/>    alerts_config = optional(object({<br/>      enabled     = optional(bool, true),<br/>      frequency   = optional(string, ""),<br/>      window_size = optional(string, ""),<br/>      severity    = optional(number, 3),<br/>      email_to    = optional(string, ""),<br/>    }), {}),<br/>    runbook_schedules = optional(list(object({<br/>      name        = string,<br/>      frequency   = string,<br/>      interval    = optional(number, null),<br/>      start_time  = string, # ISO 8601 format<br/>      timezone    = optional(string, "Europe/Stockholm")<br/>      expiry_time = optional(string, ""),<br/>      description = string,<br/>      week_days   = optional(list(string), []),<br/>      operation   = string,<br/>      node_pools  = optional(list(string), []),<br/>    })), [])<br/>  })</pre> | `{}` | no |
| <a name="input_aks_automation_enabled"></a> [aks\_automation\_enabled](#input\_aks\_automation\_enabled) | Should AKS automation be enabled | `bool` | `false` | no |
| <a name="input_aks_config"></a> [aks\_config](#input\_aks\_config) | The Azure Kubernetes Service (AKS) configuration | <pre>object({<br/>    version                = string<br/>    sku_tier               = optional(string, "Free")<br/>    default_node_pool_size = optional(number, 1)<br/>    # Will replace the default cluster auto scaler expander with a priority expander, <br/>    # see https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/expander/priority/readme.md#configuration<br/>    priority_expander_config = optional(map(list(string)))<br/>    node_pools = list(object({<br/>      name              = string<br/>      version           = string<br/>      vm_size           = string<br/>      zones             = optional(list(string), ["1", "2", "3"])<br/>      min_count         = number<br/>      max_count         = number<br/>      spot_enabled      = bool<br/>      spot_max_price    = number<br/>      node_taints       = list(string)<br/>      node_labels       = map(string)<br/>      upgrade_settings = optional(object({<br/>        drain_timeout_in_minutes      = optional(number, 30)<br/>        node_soak_duration_in_minutes = optional(number, 0)<br/>        max_surge                     = optional(number, 33)<br/>        }), {<br/>        drain_timeout_in_minutes      = 30<br/>        node_soak_duration_in_minutes = 0<br/>        max_surge                     = 33<br/>      })<br/>    }))<br/>    upgrade_settings = optional(object({<br/>      drain_timeout_in_minutes      = optional(number, 30)<br/>      node_soak_duration_in_minutes = optional(number, 0)<br/>      max_surge                     = optional(number, 33)<br/>      }), {<br/>      drain_timeout_in_minutes      = 30<br/>      node_soak_duration_in_minutes = 0<br/>      max_surge                     = 33<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_aks_cost_analysis_enabled"></a> [aks\_cost\_analysis\_enabled](#input\_aks\_cost\_analysis\_enabled) | If AKS cost analysis should be enabled | `bool` | `false` | no |
| <a name="input_aks_default_node_pool_vm_size"></a> [aks\_default\_node\_pool\_vm\_size](#input\_aks\_default\_node\_pool\_vm\_size) | The VM size of the AKS clusters default node pool. Do not override unless explicitly required. | `string` | `"Standard_D2ds_v5"` | no |
| <a name="input_aks_default_node_pool_zones"></a> [aks\_default\_node\_pool\_zones](#input\_aks\_default\_node\_pool\_zones) | The default node pool zones. | `list(string)` | <pre>[<br/>  "1",<br/>  "2",<br/>  "3"<br/>]</pre> | no |
| <a name="input_aks_joblogs_retention_days"></a> [aks\_joblogs\_retention\_days](#input\_aks\_joblogs\_retention\_days) | How many days to keep logs from automation jobs | `number` | `7` | no |
| <a name="input_aks_name_suffix"></a> [aks\_name\_suffix](#input\_aks\_name\_suffix) | The suffix for the Azure Kubernetes Service (AKS) clusters | `number` | n/a | yes |
| <a name="input_aks_public_ip_prefix_id"></a> [aks\_public\_ip\_prefix\_id](#input\_aks\_public\_ip\_prefix\_id) | Public IP ID AKS egresses from | `string` | n/a | yes |
| <a name="input_alerts_enabled"></a> [alerts\_enabled](#input\_alerts\_enabled) | If metric alerts on audit logs are enabled | `bool` | `false` | no |
| <a name="input_audit_config"></a> [audit\_config](#input\_audit\_config) | Kubernetes audit log configuration | <pre>object({<br/>    destination_type = optional(string, "StorageAccount")<br/>    analytics_workspace = optional(object({<br/>      sku_name       = optional(string, "PerGB2018")<br/>      daily_quota_gb = optional(number, -1)<br/>      reservation_gb = optional(number, 0)<br/>      retention_days = optional(number, 30)<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | Prefix for Azure AD Groups | `string` | `"az"` | no |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | If the Azure Policy for Kubernetes add-on should be enabled | `bool` | `false` | no |
| <a name="input_cilium_enabled"></a> [cilium\_enabled](#input\_cilium\_enabled) | If enabled, will use Azure CNI with Cilium instead of kubenet | `bool` | `false` | no |
| <a name="input_core_name"></a> [core\_name](#input\_core\_name) | The commonName for the core infrastructure | `string` | n/a | yes |
| <a name="input_defender_config"></a> [defender\_config](#input\_defender\_config) | The Microsoft Defender for containers configuration | <pre>object({<br/>    analytics_workspace = optional(object({<br/>      sku_name       = optional(string, "PerGB2018")<br/>      daily_quota_gb = optional(number, -1)<br/>      reservation_gb = optional(number, 0)<br/>      retention_days = optional(number, 30)<br/>    }), {})<br/>    kubernetes_discovery_enabled      = optional(bool, false)<br/>    kubernetes_sensor_enabled         = optional(bool, true)<br/>    vulnerability_assessments_enabled = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_defender_enabled"></a> [defender\_enabled](#input\_defender\_enabled) | If Defender for Containers should be enabled | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_group_name_separator"></a> [group\_name\_separator](#input\_group\_name\_separator) | Separator for group names | `string` | `"-"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region | `string` | `"West Europe"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_log_eventhub_authorization_rule_id"></a> [log\_eventhub\_authorization\_rule\_id](#input\_log\_eventhub\_authorization\_rule\_id) | The authoritzation rule id for event hub | `string` | n/a | yes |
| <a name="input_log_eventhub_name"></a> [log\_eventhub\_name](#input\_log\_eventhub\_name) | The eventhub name for k8s logs | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes | <pre>list(<br/>    object({<br/>      name = string<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Where to send email alerts | `string` | `"DG-Team-DevOps@xenit.se"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key to add to servers | `string` | n/a | yes |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The commonName for the subscription | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kube config for the created AKS cluster |
