# Flux (v1)

This module is used to add [`flux`](https://github.com/fluxcd/flux) to Kubernetes clusters.

## Details

The helm chart is added to this module to add the securityContext parameters to the pod running flux, to make sure it works with the `opa-gatekeeper` module.

This module will create a flux instance in each namespace, and not used for fleet-wide configuration.

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
| azdo\_proxy\_enabled | Should azdo-proxy integration be enabled | `bool` | `true` | no |
| azdo\_proxy\_local\_passwords | The passwords (per namespace) to communicate with Azure DevOps Proxy | `map(string)` | `{}` | no |
| fluxcd\_v1\_git\_path | The git path for fluxcd-v1 | `string` | `""` | no |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled      = bool<br>        azdo_org     = string<br>        azdo_project = string<br>        azdo_repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

