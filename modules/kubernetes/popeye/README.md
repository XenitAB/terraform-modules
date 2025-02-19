# Popeye (popeye)

This module is used to add Popeye [`popeye`](https://github.com/derailed/popeye) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.popeye](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.aks_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.popeye_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.popeye](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/user_assigned_identity) | resource |
| [helm_release.popeye](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_namespace.popeye](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [azurerm_storage_account.log](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_managed_identity_id"></a> [aks\_managed\_identity\_id](#input\_aks\_managed\_identity\_id) | The principal id of the AKS managed identity | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The AKS cluster id | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | The AKS token exchange URL | `string` | n/a | yes |
| <a name="input_popeye_config"></a> [popeye\_config](#input\_popeye\_config) | The popeye configuration | <pre>object({<br/>    allowed_registries = optional(list(string), [])<br/>    cron_jobs = optional(list(object({<br/>      namespace     = optional(string, "default")<br/>      resources     = optional(string, "cj,cm,deploy,ds,gw,gwc,gwr,hpa,ing,job,np,pdb,po,pv,pvc,ro,rb,sa,sec,sts,svc")<br/>      output_format = optional(string, "html")<br/>      schedule      = optional(string, "0 0 * * 1")<br/>    })), [{}])<br/>    storage_account = optional(object({<br/>      resource_group_name = optional(string, "")<br/>      account_name        = optional(string, "")<br/>      file_share_size     = optional(string, "1Gi")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure AKS resource group name | `string` | n/a | yes |

## Outputs

No outputs.
