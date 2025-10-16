# Gatekeeper

Adds [`gatekeeper`](https://github.com/open-policy-agent/gatekeeper) to a Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.gatekeeper](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_app](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_chart](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_config](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_config_manifest](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_template_manifest](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_templates](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_values](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_service_operator_enabled"></a> [azure\_service\_operator\_enabled](#input\_azure\_service\_operator\_enabled) | If Azure Service Operator should be enabled | `bool` | `false` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_exclude_namespaces"></a> [exclude\_namespaces](#input\_exclude\_namespaces) | Namespaces to exclude from admission and mutation. | `list(string)` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_mirrord_enabled"></a> [mirrord\_enabled](#input\_mirrord\_enabled) | If Gatekeeper validations should make an exemption for mirrord agent. | `bool` | `false` | no |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
