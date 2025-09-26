## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.dex](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application) | resource |
| [azuread_application_password.dex](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application_password) | resource |
| [azurerm_federated_identity_credential.argocd_application_controller](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_federated_identity_credential.argocd_server](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault_access_policy.argocd](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_role_assignment.argocd_admin](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.argocd](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.argocd](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.argocd_app](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.argocd_chart](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.argocd_extras](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.argocd_extras_manifests](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.argocd_values](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [helm_release.argocd_hub_setup](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [helm_release.argocd_spoke_setup](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_namespace.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [azuread_group.all_owner](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.core](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.pat](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/key_vault_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_cluster_id"></a> [aks\_cluster\_id](#input\_aks\_cluster\_id) | AKS cluster id. | `string` | n/a | yes |
| <a name="input_argocd_config"></a> [argocd\_config](#input\_argocd\_config) | ArgoCD configuration | <pre>object({<br/>    aad_group_name                  = optional(string, "az-sub-xks-all-owner")<br/>    cluster_role                    = optional(string, "Spoke")<br/>    application_set_replicas        = optional(number, 2)<br/>    controller_replicas             = optional(number, 3)<br/>    repo_server_replicas            = optional(number, 2)<br/>    server_replicas                 = optional(number, 2)<br/>    dynamic_sharding                = optional(bool, false)<br/>    controller_status_processors    = optional(number, 50)<br/>    controller_operation_processors = optional(number, 100)<br/>    argocd_k8s_client_qps           = optional(number, 150)<br/>    argocd_k8s_client_burst         = optional(number, 300)<br/>    redis_enabled                   = optional(bool, true)<br/>    global_domain                   = optional(string, "")<br/>    ingress_whitelist_ip            = optional(string, "")<br/>    dex_tenant_name                 = optional(string, "")<br/>    dex_redirect_domains            = optional(string, "")<br/>    oidc_issuer_url                 = optional(map(string), {})<br/>    sync_windows = optional(list(object({<br/>      kind        = string<br/>      schedule    = string<br/>      duration    = string<br/>      manual_sync = optional(bool, true)<br/>    })), [])<br/>    azure_tenants = optional(list(object({<br/>      tenant_name = string<br/>      tenant_id   = string<br/>      clusters = list(object({<br/>        name            = string<br/>        api_server      = string<br/>        environment     = string<br/>        azure_client_id = optional(string, "")<br/>        ca_data         = optional(string, "")<br/>        tenants = list(object({<br/>          # This will be used to only if cluster_role is set to 'Hub-Spoke' to create AppProject <br/>          # roles that limit access to the project, based on the AAD group we create for each <br/>          # tenant namespace.<br/>          aad_group              = optional(string, "")<br/>          name                   = string<br/>          namespace              = string<br/>          repo_url               = string<br/>          repo_path              = string<br/>          github_app_id          = string<br/>          github_installation_id = string<br/>          secret_name            = string<br/><br/>        }))<br/>      }))<br/>    })), [])<br/>  })</pre> | `{}` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_core_resource_group_name"></a> [core\_resource\_group\_name](#input\_core\_resource\_group\_name) | The Azure core resource group name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra config | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The Azure core key vault name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
