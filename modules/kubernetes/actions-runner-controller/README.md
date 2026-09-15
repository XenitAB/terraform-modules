# GitHub Actions Runner Controller (ARC)

This module is used to add the [`gha-runner-scale-set-controller`](https://github.com/actions/actions-runner-controller)
to Kubernetes clusters.

The controller is always deployed. The runner scale set and its GitHub App
credentials (ExternalSecret) are only generated when `arc_runner_set_config`
is set, since they're tenant-specific (target org/repo, GitHub App).

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.57.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.57.0 |
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_federated_identity_credential.arc_external_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/federated_identity_credential) | resource |
| [git_repository_file.arc_app](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_chart](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_controller](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_external_secret](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_runner_set](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_values](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [azurerm_user_assigned_identity.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | The AKS cluster short name, e.g. 'aks'. Required if arc\_runner\_set\_config is set. | `string` | `""` | no |
| <a name="input_arc_config"></a> [arc\_config](#input\_arc\_config) | Configuration for the GitHub Actions Runner Controller (ARC) controller deployment. | <pre>object({<br/>    chart_version             = optional(string, "0.14.2")<br/>    namespace                 = optional(string, "arc-system")<br/>    replica_count             = optional(number, 1)<br/>    watch_single_namespace    = optional(string, "")<br/>    resources_cpu_requests    = optional(string, "50m")<br/>    resources_memory_requests = optional(string, "128Mi")<br/>    resources_memory_limit    = optional(string, "512Mi")<br/>  })</pre> | `{}` | no |
| <a name="input_arc_runner_set_config"></a> [arc\_runner\_set\_config](#input\_arc\_runner\_set\_config) | Configuration for the runner scale set and its GitHub App credentials. Leave null to deploy only the controller. | <pre>object({<br/>    runner_scale_set_name      = string<br/>    github_config_url          = string<br/>    github_app_id              = string<br/>    github_app_installation_id = string<br/>    key_vault_name             = string<br/>    key_vault_secret_name      = optional(string, "github-arc-private-key")<br/>    min_runners                = optional(number, 0)<br/>    max_runners                = optional(number, 8)<br/>  })</pre> | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure AD tenant ID for the ExternalSecret's SecretStore. Required if arc\_runner\_set\_config is set. | `string` | `""` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The short name of the Azure region, e.g. 'sdc'. Required if arc\_runner\_set\_config is set. | `string` | `""` | no |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_eso_client_id"></a> [eso\_client\_id](#output\_eso\_client\_id) | Client ID of the shared identity federated for the runner scale set's ExternalSecret. Null if arc\_runner\_set\_config was not set. |
