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
| acr\_name | Name of ACR registry to use for cluster | `string` | n/a | yes |
| azdo\_proxy\_enabled | Should azdo-proxy integration be enabled | `bool` | `true` | no |
| azdo\_proxy\_local\_passwords | The passwords (per namespace) to communicate with Azure DevOps Proxy | `map(string)` | `{}` | no |
| helm\_operator\_credentials | ACR credentials pased to Helm Operator | <pre>object({<br>    client_id = string<br>    secret    = string<br>  })</pre> | n/a | yes |
| helm\_operator\_helm\_chart\_name | The helm chart name for helm-operator | `string` | `"helm-operator"` | no |
| helm\_operator\_helm\_chart\_version | The helm chart version for helm-operator | `string` | `"1.1.0"` | no |
| helm\_operator\_helm\_release\_name | The helm release name for helm-operator | `string` | `"helm-operator"` | no |
| helm\_operator\_helm\_repository | The helm repository for helm-operator | `string` | `"https://charts.fluxcd.io"` | no |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled      = bool<br>        azdo_org     = string<br>        azdo_project = string<br>        azdo_repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

