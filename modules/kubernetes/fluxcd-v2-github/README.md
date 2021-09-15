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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.3.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.14.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.11.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.5.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | 0.3.1 |
| <a name="provider_github"></a> [github](#provider\_github) | 4.14.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.11.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.5.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_deploy_key.cluster](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/resources/repository_deploy_key) | resource |
| [github_repository_deploy_key.tenant](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/resources/repository_deploy_key) | resource |
| [github_repository_file.cluster_tenants](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/resources/repository_file) | resource |
| [github_repository_file.install](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/resources/repository_file) | resource |
| [github_repository_file.kustomize](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/resources/repository_file) | resource |
| [github_repository_file.sync](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/resources/repository_file) | resource |
| [github_repository_file.tenant](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/resources/repository_file) | resource |
| [kubectl_manifest.install](https://registry.terraform.io/providers/gavinbunney/kubectl/1.11.3/docs/resources/manifest) | resource |
| [kubectl_manifest.sync](https://registry.terraform.io/providers/gavinbunney/kubectl/1.11.3/docs/resources/manifest) | resource |
| [kubernetes_namespace.flux_system](https://registry.terraform.io/providers/hashicorp/kubernetes/2.5.0/docs/resources/namespace) | resource |
| [kubernetes_secret.cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/2.5.0/docs/resources/secret) | resource |
| [kubernetes_secret.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.5.0/docs/resources/secret) | resource |
| [tls_private_key.cluster](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [tls_private_key.tenant](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [flux_install.this](https://registry.terraform.io/providers/fluxcd/flux/0.3.1/docs/data-sources/install) | data source |
| [flux_sync.this](https://registry.terraform.io/providers/fluxcd/flux/0.3.1/docs/data-sources/sync) | data source |
| [github_repository.cluster](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/data-sources/repository) | data source |
| [github_repository.tenant](https://registry.terraform.io/providers/integrations/github/4.14.0/docs/data-sources/repository) | data source |
| [kubectl_file_documents.install](https://registry.terraform.io/providers/gavinbunney/kubectl/1.11.3/docs/data-sources/file_documents) | data source |
| [kubectl_file_documents.sync](https://registry.terraform.io/providers/gavinbunney/kubectl/1.11.3/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch"></a> [branch](#input\_branch) | Branch to point source controller towards | `string` | `"main"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Environment name of the cluster | `string` | n/a | yes |
| <a name="input_cluster_repo"></a> [cluster\_repo](#input\_cluster\_repo) | Name of cluster repository | `string` | `"fleet-infra"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name of the cluster | `string` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | Owner of GitHub repositories | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled = bool<br>        repo    = string<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
