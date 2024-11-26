## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.16.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.this](https://registry.terraform.io/providers/gavinbunney/kubectl/1.16.0/docs/resources/manifest) | resource |
| [helm_template.this](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/data-sources/template) | data source |
| [kubectl_file_documents.this](https://registry.terraform.io/providers/gavinbunney/kubectl/1.16.0/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm Chart repository | `string` | n/a | yes |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm Chart repository | `string` | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm Chart repository | `string` | n/a | yes |
| <a name="input_values"></a> [values](#input\_values) | Extra values to pass when templating | `map(any)` | `{}` | no |

## Outputs

No outputs.
