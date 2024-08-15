# Azure AD Application configuration for Azure AD Kubernetes API Proxy

This module is used to configure the Azure AD Application used by [`azad-kube-proxy`](https://github.com/XenitAB/azad-kube-proxy).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.ms_graph_directory_read_all](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/app_role_assignment) | resource |
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application) | resource |
| [azuread_application_password.this](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application_password) | resource |
| [azuread_application_pre_authorized.azure_cli](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application_pre_authorized) | resource |
| [azuread_service_principal.ms_graph](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/service_principal) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/service_principal) | resource |
| [random_uuid.oauth2_permission_scope_user_impersonation](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/uuid) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/application_published_app_ids) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name that will show up in the discovery and be used as the context for the kubeconfig. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the Azure AD application. | `string` | n/a | yes |
| <a name="input_proxy_url"></a> [proxy\_url](#input\_proxy\_url) | The URL to the azad-kube-proxy, will be used for identified\_uris and proxy\_url tag. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data"></a> [data](#output\_data) | The Azure AD Application data for azad-kube-proxy |
