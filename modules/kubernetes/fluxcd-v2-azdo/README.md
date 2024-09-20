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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >=1.3.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.25.3 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | 1.3.0 |
| <a name="provider_flux"></a> [flux](#provider\_flux) | 0.25.3 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuredevops_git_repository_file.cluster_tenants](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
| [azuredevops_git_repository_file.install](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
| [azuredevops_git_repository_file.kustomize](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
| [azuredevops_git_repository_file.sync](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
| [azuredevops_git_repository_file.tenant](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository_file) | resource |
| [git_repository_file.flux_alerts](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [helm_release.git_auth_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubectl_manifest.install](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.sync](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [azuredevops_git_repository.cluster](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/git_repository) | data source |
| [azuredevops_project.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [flux_install.this](https://registry.terraform.io/providers/fluxcd/flux/0.25.3/docs/data-sources/install) | data source |
| [flux_sync.this](https://registry.terraform.io/providers/fluxcd/flux/0.25.3/docs/data-sources/sync) | data source |
| [kubectl_file_documents.install](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/data-sources/file_documents) | data source |
| [kubectl_file_documents.sync](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_devops_org"></a> [azure\_devops\_org](#input\_azure\_devops\_org) | Azure DevOps organization for bootstrap repository | `string` | n/a | yes |
| <a name="input_azure_devops_pat"></a> [azure\_devops\_pat](#input\_azure\_devops\_pat) | PAT to authenticate with Azure DevOps | `string` | n/a | yes |
| <a name="input_azure_devops_proj"></a> [azure\_devops\_proj](#input\_azure\_devops\_proj) | Azure DevOps project for bootstrap repository | `string` | n/a | yes |
| <a name="input_branch"></a> [branch](#input\_branch) | Branch to point source controller towards | `string` | `"main"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_cluster_repo"></a> [cluster\_repo](#input\_cluster\_repo) | Name of cluster repository | `string` | `"fleet-infra"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name of the cluster | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled             = bool<br>        create_crds         = bool<br>        include_tenant_name = bool<br>        org                 = string<br>        proj                = string<br>        repo                = string<br>      })<br>    })<br>  )</pre> | <pre>[<br>  {<br>    "flux": {<br>      "create_crds": false,<br>      "enabled": true,<br>      "include_tenant_name": false,<br>      "org": "",<br>      "proj": "",<br>      "repo": ""<br>    },<br>    "name": ""<br>  }<br>]</pre> | no |
| <a name="input_slack_flux_alert_config"></a> [slack\_flux\_alert\_config](#input\_slack\_flux\_alert\_config) | A webhook address for sending alerts to slack | <pre>object({<br>    xenit_webhook  = string<br>    tenant_webhook = string<br><br>  })</pre> | <pre>{<br>  "tenant_webhook": "",<br>  "xenit_webhook": ""<br>}</pre> | no |

## Outputs

No outputs.
