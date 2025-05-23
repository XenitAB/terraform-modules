## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.4.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |
| <a name="provider_flux"></a> [flux](#provider\_flux) | 1.4.0 |
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.flux_system](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.flux_managed](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.flux_system_acr](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.flux_system](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/user_assigned_identity) | resource |
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/1.4.0/docs/resources/bootstrap_git) | resource |
| [git_repository_file.tenant](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [helm_release.git_auth_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_namespace.flux_system](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.git_auth_proxy](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/container_registry) | data source |
| [azurerm_resource_group.global](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name_override"></a> [acr\_name\_override](#input\_acr\_name\_override) | Override default name of ACR | `string` | `""` | no |
| <a name="input_aks_managed_identity"></a> [aks\_managed\_identity](#input\_aks\_managed\_identity) | AKS Azure AD managed identity | `string` | n/a | yes |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_bootstrap"></a> [bootstrap](#input\_bootstrap) | Repository configuration to use for bootstrap. | <pre>object({<br/>    disable_secret_creation = optional(bool, true)<br/>    project                 = optional(string)<br/>    repository              = string<br/>  })</pre> | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name of the cluster. | `string` | n/a | yes |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider for repositories. | <pre>object({<br/>    organization = string<br/>    type         = optional(string, "azuredevops")<br/>    github = optional(object({<br/>      application_id  = number<br/>      installation_id = number<br/>      private_key     = string<br/>    }))<br/>    azure_devops = optional(object({<br/>      pat = string<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Flux tenants to add. | <pre>list(<br/>    object({<br/>      name   = string<br/>      labels = optional(map(string), null)<br/>      fluxcd = optional(object({<br/>        provider            = string<br/>        project             = optional(string)<br/>        repository          = string<br/>        include_tenant_name = optional(bool, false)<br/>        create_crds         = optional(bool, true)<br/>      }))<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix that is used in globally unique resources names | `string` | `""` | no |

## Outputs

No outputs.
