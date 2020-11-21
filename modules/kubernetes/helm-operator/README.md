# Helm Operator (helm-operator)

This module is used to add [`helm-operator`](https://github.com/fluxcd/helm-operator) to Kubernetes clusters.

## Details

This module will create a helm-operator instance in each namespace, and not used for fleet-wide configuration.

Will be deprecated as soon as Flux v2 module is finished and tested.

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
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled      = bool<br>        azdo_org     = string<br>        azdo_project = string<br>        azdo_repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

