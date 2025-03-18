# Gatekeeper

Adds [`gatekeeper`](https://github.com/open-policy-agent/gatekeeper) to a Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.gatekeeper](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_config](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.gatekeeper_template](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_service_operator_enabled"></a> [azure\_service\_operator\_enabled](#input\_azure\_service\_operator\_enabled) | If Azure Service Operator should be enabled | `bool` | `false` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_exclude_namespaces"></a> [exclude\_namespaces](#input\_exclude\_namespaces) | Namespaces to exclude from admission and mutation. | `list(string)` | n/a | yes |
| <a name="input_mirrord_enabled"></a> [mirrord\_enabled](#input\_mirrord\_enabled) | If Gatekeeper validations should make an exemption for mirrord agent. | `bool` | `false` | no |
| <a name="input_telepresence_enabled"></a> [telepresence\_enabled](#input\_telepresence\_enabled) | If Gatekeeper validations should make an exemption for telepresence agent. | `bool` | `false` | no |

## Outputs

No outputs.
