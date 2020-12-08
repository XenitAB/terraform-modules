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
| kubernetes | 1.13.3 |
| random | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| helm | 1.3.2 |
| kubernetes | 1.13.3 |
| random | 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_devops\_domain | Domain for azure devops | `string` | `"dev.azure.com"` | no |
| azure\_devops\_org | Azure DevOps organization for bootstrap repository | `string` | n/a | yes |
| azure\_devops\_pat | PAT to authenticate with Azure DevOps | `string` | n/a | yes |
| environment | Environment name of the cluster | `string` | n/a | yes |
| namespaces | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled = bool<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

