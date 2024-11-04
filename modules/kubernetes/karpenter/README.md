# Karpenter (karpenter)

This module is used to add self-hosted [`karpenter`](https://github.com/Azure/karpenter-provider-azure) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.7.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.7.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.karpenter](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.karpenter_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.karpenter](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/user_assigned_identity) | resource |
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubectl_manifest.node_classes](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.node_pools](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.secret](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_config"></a> [aks\_config](#input\_aks\_config) | AKScluster configuration | <pre>object({<br/>    cluster_id             = string<br/>    cluster_name           = string<br/>    cluster_endpoint       = string<br/>    bootstrap_token        = string<br/>    default_node_pool_size = number<br/>    node_identities        = string<br/>    node_resource_group    = string<br/>    oidc_issuer_url        = string<br/>    ssh_public_key         = string<br/>    vnet_subnet_id         = string<br/>  })</pre> | n/a | yes |
| <a name="input_karpenter_config"></a> [karpenter\_config](#input\_karpenter\_config) | Karpenter configuration for the AKS cluster | <pre>object({<br/>    node_ttl      = optional(string, "168h")<br/>    replica_count = optional(number, 2)<br/>    node_classes = optional(list(object({<br/>      name         = optional(string, "default")<br/>      image_family = optional(string, "Ubuntu2204")<br/>      kubelet = optional(object({<br/>        container_log_max_size  = optional(string, "10Mi")<br/>        cpu_cfs_quota           = optional(bool, true)<br/>        cpu_cfs_quota_period    = optional(string, "100ms")<br/>        cpu_manager_policy      = optional(string, "none")<br/>        topology_manager_policy = optional(string, "none")<br/>      }), {})<br/>    })), [{}])<br/>    node_pools = optional(list(object({<br/>      name              = string<br/>      consolidate_after = optional(string, "5s")<br/>      description       = string<br/>      disruption_budgets = optional(list(object({<br/>        duration = optional(string, null)<br/>        nodes    = optional(string, "10%")<br/>        reasons  = optional(list(string), ["Drifted", "Empty", "Underutilized"])<br/>        schedule = optional(string, null)<br/>      })), [])<br/>      limits = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>      node_annotations = optional(map(string), {})<br/>      node_class_ref   = optional(string, "default")<br/>      node_labels      = optional(map(string), {})<br/>      node_requirements = optional(list(object({<br/>        key      = string<br/>        operator = string<br/>        values   = list(string)<br/>      })), [])<br/>      node_taints = optional(list(object({<br/>        key    = string<br/>        effect = string<br/>        value  = string<br/>      })), [])<br/>      node_ttl = optional(string, "168h")<br/>      weight   = optional(number, 1)<br/>    })), [])<br/>    settings = optional(object({<br/>      batch_idle_duration = optional(string, "1s")<br/>      batch_max_duration  = optional(string, "10s")<br/>    }), {})<br/>  })</pre> | <pre>{<br/>  "bootstrap_token": "",<br/>  "cluster_endpoint": "",<br/>  "node_identities": "",<br/>  "ssh_public_key": "",<br/>  "vnet_subnet_id": ""<br/>}</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure AKS resource group name | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription id | `string` | n/a | yes |

## Outputs

No outputs.
