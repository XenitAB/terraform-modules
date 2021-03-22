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
| flux | 0.1.0 |
| helm | 2.0.3 |
| kubectl | 1.10.0 |
| kubernetes | 2.0.3 |
| random | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azuredevops | 0.3.0 |
| flux | 0.1.0 |
| helm | 2.0.3 |
| kubectl | 1.10.0 |
| kubernetes | 2.0.3 |
| random | 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azuredevops_git_repository](https://registry.terraform.io/providers/xenitab/azuredevops/0.3.0/docs/data-sources/git_repository) |
| [azuredevops_git_repository_file](https://registry.terraform.io/providers/xenitab/azuredevops/0.3.0/docs/resources/git_repository_file) |
| [azuredevops_project](https://registry.terraform.io/providers/xenitab/azuredevops/0.3.0/docs/data-sources/project) |
| [flux_install](https://registry.terraform.io/providers/fluxcd/flux/0.1.0/docs/data-sources/install) |
| [flux_sync](https://registry.terraform.io/providers/fluxcd/flux/0.1.0/docs/data-sources/sync) |
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/2.0.3/docs/resources/release) |
| [kubectl_file_documents](https://registry.terraform.io/providers/gavinbunney/kubectl/1.10.0/docs/data-sources/file_documents) |
| [kubectl_manifest](https://registry.terraform.io/providers/gavinbunney/kubectl/1.10.0/docs/resources/manifest) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.3/docs/resources/namespace) |
| [kubernetes_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.3/docs/resources/secret) |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_devops\_org | Azure DevOps organization for bootstrap repository | `string` | n/a | yes |
| azure\_devops\_pat | PAT to authenticate with Azure DevOps | `string` | n/a | yes |
| azure\_devops\_proj | Azure DevOps project for bootstrap repository | `string` | n/a | yes |
| branch | Branch to point source controller towards | `string` | `"main"` | no |
| cluster\_repo | Name of cluster repository | `string` | `"fleet-infra"` | no |
| environment | Environment name of the cluster | `string` | n/a | yes |
| namespaces | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled = bool<br>        org     = string<br>        proj    = string<br>        repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.
