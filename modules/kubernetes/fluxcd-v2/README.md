# Flux V2

The module installs and configures [flux2](https://github.com/fluxcd/flux2) with Azure DevOps.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azuredevops | 0.2.1 |
| flux | 0.0.4 |
| kubectl | 1.9.1 |
| kubernetes | 1.13.3 |

## Providers

| Name | Version |
|------|---------|
| azuredevops | 0.2.1 |
| flux | 0.0.4 |
| kubectl | 1.9.1 |
| kubernetes | 1.13.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azdo\_org | Azure DevOps organization for bootstrap repository | `string` | n/a | yes |
| azdo\_pat | PAT to authenticate with Azure DevOps | `string` | n/a | yes |
| azdo\_proj | Azure DevOps project for bootstrap repository | `string` | n/a | yes |
| azdo\_repo | Name of repository to bootstrap from | `string` | `"fleet-infra"` | no |
| branch | Path to reconcile bootstrap from | `string` | `"master"` | no |
| git\_path | Path to reconcile bootstrap from | `string` | n/a | yes |
| namespaces | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled      = bool<br>        azdo_org     = string<br>        azdo_project = string<br>        azdo_repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

