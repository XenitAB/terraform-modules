# Flux V2

Installs and configures [flux2](https://github.com/fluxcd/flux2) with GitHub.

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
| flux | 0.0.14 |
| github | 4.5.2 |
| kubectl | 1.10.0 |
| kubernetes | 2.0.3 |
| tls | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| flux | 0.0.14 |
| github | 4.5.2 |
| kubectl | 1.10.0 |
| kubernetes | 2.0.3 |
| tls | 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [flux_install](https://registry.terraform.io/providers/fluxcd/flux/0.0.14/docs/data-sources/install) |
| [flux_sync](https://registry.terraform.io/providers/fluxcd/flux/0.0.14/docs/data-sources/sync) |
| [github_repository](https://registry.terraform.io/providers/integrations/github/4.5.2/docs/data-sources/repository) |
| [github_repository_deploy_key](https://registry.terraform.io/providers/integrations/github/4.5.2/docs/resources/repository_deploy_key) |
| [github_repository_file](https://registry.terraform.io/providers/integrations/github/4.5.2/docs/resources/repository_file) |
| [kubectl_file_documents](https://registry.terraform.io/providers/gavinbunney/kubectl/1.10.0/docs/data-sources/file_documents) |
| [kubectl_manifest](https://registry.terraform.io/providers/gavinbunney/kubectl/1.10.0/docs/resources/manifest) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.3/docs/resources/namespace) |
| [kubernetes_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.3/docs/resources/secret) |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| branch | Branch to point source controller towards | `string` | `"main"` | no |
| cluster\_repo | Name of cluster repository | `string` | `"fleet-infra"` | no |
| environment | Environment name of the cluster | `string` | n/a | yes |
| github\_owner | Owner of GitHub repositories | `string` | n/a | yes |
| namespaces | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled = bool<br>        repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.
