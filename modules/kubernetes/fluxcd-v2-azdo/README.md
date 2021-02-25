# Flux V2

Installs and configures [flux2](https://github.com/fluxcd/flux2) with Azure DevOps.

The module is meant to offer a full bootstrap and confiugration of a Kubernetes cluster  
with Fluxv2. A "root" repository is created for the bootstrap configuration along with a  
repository per namepsace passed in the variables. The root repository will receive `cluster-admin`  
permissions in the cluster while each of the namespace repositories will be limited to their  
repsective namespace. The CRDs, component deployments and bootstrap configuration are both  
added to the Kubernetes cluster and commited to the root repository. While the namespace  
configuration is only comitted to the root repository and expected to be reconciled through  
the bootstrap configuration.

![flux-arch](../../../assets/fluxcd-v2.jpg)

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| azuredevops | 0.3.0 |
| flux | 0.0.12 |
| kubectl | 1.10.0 |
| kubernetes | 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| azuredevops | 0.3.0 |
| flux | 0.0.12 |
| kubectl | 1.10.0 |
| kubernetes | 2.0.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_devops\_org | Azure DevOps organization for bootstrap repository | `string` | n/a | yes |
| azure\_devops\_pat | PAT to authenticate with Azure DevOps | `string` | n/a | yes |
| azure\_devops\_proj | Azure DevOps project for bootstrap repository | `string` | n/a | yes |
| bootstrap\_path | Path to reconcile bootstrap from | `string` | n/a | yes |
| bootstrap\_repo | Name of repository to bootstrap from | `string` | `"fleet-infra"` | no |
| branch | Path to reconcile bootstrap from | `string` | `"master"` | no |
| namespaces | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled = bool<br>        repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

