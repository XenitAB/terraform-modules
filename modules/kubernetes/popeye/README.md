# Popeye (popeye)

This module is used to add Popeye [`popeye`](https://github.com/derailed/popeye) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.popeye](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.aks_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.popeye_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.popeye](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.cluster_role](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.cluster_role_binding](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.config_map](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.cronjob](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.helmignore](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.popeye](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.pvc](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.secret](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.service_account](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.storage_class](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.values](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [azurerm_storage_account.log](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_managed_identity_id"></a> [aks\_managed\_identity\_id](#input\_aks\_managed\_identity\_id) | The principal id of the AKS managed identity | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The AKS cluster id | `string` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | The AKS token exchange URL | `string` | n/a | yes |
| <a name="input_popeye_config"></a> [popeye\_config](#input\_popeye\_config) | The popeye configuration | <pre>object({<br/>    allowed_registries = optional(list(string), [])<br/>    cron_jobs = optional(list(object({<br/>      namespace     = optional(string, "default")<br/>      resources     = optional(string, "cj,cm,deploy,ds,gw,gwc,gwr,hpa,ing,job,np,pdb,po,pv,pvc,ro,rb,sa,sec,sts,svc")<br/>      output_format = optional(string, "html")<br/>      schedule      = optional(string, "0 0 * * 1")<br/>    })), [{}])<br/>    storage_account = optional(object({<br/>      resource_group_name = optional(string, "")<br/>      account_name        = optional(string, "")<br/>      file_share_size     = optional(string, "1Gi")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure AKS resource group name | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
