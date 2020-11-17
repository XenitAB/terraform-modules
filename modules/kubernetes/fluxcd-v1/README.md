## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 1.3.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 1.3.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azdo\_proxy\_enabled | Should azdo-proxy integration be enabled | `bool` | `true` | no |
| azdo\_proxy\_local\_passwords | The passwords (per namespace) to communicate with Azure DevOps Proxy | `map(string)` | `{}` | no |
| fluxcd\_v1\_git\_path | The git path for fluxcd-v1 | `string` | `""` | no |
| fluxcd\_v1\_helm\_chart\_name | The helm chart name for fluxcd-v1 | `string` | `"flux"` | no |
| fluxcd\_v1\_helm\_chart\_version | The helm chart version for fluxcd-v1 | `string` | `"1.3.0"` | no |
| fluxcd\_v1\_helm\_release\_name | The helm release name for fluxcd-v1 | `string` | `"fluxcd-v1"` | no |
| fluxcd\_v1\_helm\_repository | The helm repository for fluxcd-v1 | `string` | `"https://charts.fluxcd.io"` | no |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled      = bool<br>        azdo_org     = string<br>        azdo_project = string<br>        azdo_repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

