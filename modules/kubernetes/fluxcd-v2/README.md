## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | 0.5.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.11.2 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.21.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.13.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | 0.5.0 |
| <a name="provider_flux"></a> [flux](#provider\_flux) | 0.11.2 |
| <a name="provider_github"></a> [github](#provider\_github) | 4.21.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.13.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuredevops_git_repository_file.cluster_tenants](https://registry.terraform.io/providers/xenitab/azuredevops/0.5.0/docs/resources/git_repository_file) | resource |
| [azuredevops_git_repository_file.install](https://registry.terraform.io/providers/xenitab/azuredevops/0.5.0/docs/resources/git_repository_file) | resource |
| [azuredevops_git_repository_file.kustomize](https://registry.terraform.io/providers/xenitab/azuredevops/0.5.0/docs/resources/git_repository_file) | resource |
| [azuredevops_git_repository_file.sync](https://registry.terraform.io/providers/xenitab/azuredevops/0.5.0/docs/resources/git_repository_file) | resource |
| [azuredevops_git_repository_file.tenant](https://registry.terraform.io/providers/xenitab/azuredevops/0.5.0/docs/resources/git_repository_file) | resource |
| [github_repository_file.cluster_tenants](https://registry.terraform.io/providers/integrations/github/4.21.0/docs/resources/repository_file) | resource |
| [github_repository_file.install](https://registry.terraform.io/providers/integrations/github/4.21.0/docs/resources/repository_file) | resource |
| [github_repository_file.kustomize](https://registry.terraform.io/providers/integrations/github/4.21.0/docs/resources/repository_file) | resource |
| [github_repository_file.sync](https://registry.terraform.io/providers/integrations/github/4.21.0/docs/resources/repository_file) | resource |
| [github_repository_file.tenant](https://registry.terraform.io/providers/integrations/github/4.21.0/docs/resources/repository_file) | resource |
| [helm_release.git_auth_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubectl_manifest.install](https://registry.terraform.io/providers/gavinbunney/kubectl/1.13.1/docs/resources/manifest) | resource |
| [kubectl_manifest.sync](https://registry.terraform.io/providers/gavinbunney/kubectl/1.13.1/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [azuredevops_git_repository.cluster](https://registry.terraform.io/providers/xenitab/azuredevops/0.5.0/docs/data-sources/git_repository) | data source |
| [azuredevops_project.this](https://registry.terraform.io/providers/xenitab/azuredevops/0.5.0/docs/data-sources/project) | data source |
| [flux_install.this](https://registry.terraform.io/providers/fluxcd/flux/0.11.2/docs/data-sources/install) | data source |
| [flux_sync.this](https://registry.terraform.io/providers/fluxcd/flux/0.11.2/docs/data-sources/sync) | data source |
| [github_repository.cluster](https://registry.terraform.io/providers/integrations/github/4.21.0/docs/data-sources/repository) | data source |
| [kubectl_file_documents.install](https://registry.terraform.io/providers/gavinbunney/kubectl/1.13.1/docs/data-sources/file_documents) | data source |
| [kubectl_file_documents.sync](https://registry.terraform.io/providers/gavinbunney/kubectl/1.13.1/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_devops_org"></a> [azure\_devops\_org](#input\_azure\_devops\_org) | Azure DevOps organization for bootstrap repository | `string` | `"null"` | no |
| <a name="input_azure_devops_pat"></a> [azure\_devops\_pat](#input\_azure\_devops\_pat) | PAT to authenticate with Azure DevOps | `string` | `"null"` | no |
| <a name="input_azure_devops_proj"></a> [azure\_devops\_proj](#input\_azure\_devops\_proj) | Azure DevOps project for bootstrap repository | `string` | `"null"` | no |
| <a name="input_branch"></a> [branch](#input\_branch) | Branch to point source controller towards | `string` | `"main"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_cluster_repo"></a> [cluster\_repo](#input\_cluster\_repo) | Name of cluster repository | `string` | `"fleet-infra"` | no |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | List of credentials for Git Providers. | <pre>list(object({<br>    type = string # azuredevops or github<br>    azure_devops = object({<br>      org = string<br>      pat = string<br>    })<br>    github = object({<br>      org             = string<br>      app_id          = number<br>      installation_id = number<br>      private_key     = string<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name of the cluster | `string` | n/a | yes |
| <a name="input_fleet_infra"></a> [fleet\_infra](#input\_fleet\_infra) | Configuration for Flux bootstrap repository. | <pre>object({<br>    type = string<br>    org  = string<br>    proj = string<br>    repo = string<br>  })</pre> | n/a | yes |
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | ID of GitHub Application used by Git Auth Proxy | `number` | n/a | yes |
| <a name="input_github_installation_id"></a> [github\_installation\_id](#input\_github\_installation\_id) | Installation ID of GitHub Application used by Git Auth Proxy | `number` | n/a | yes |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | Org of GitHub repositories | `string` | n/a | yes |
| <a name="input_github_private_key"></a> [github\_private\_key](#input\_github\_private\_key) | Private Key for GitHub Application used by Git Auth Proxy | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name        = string<br>      create_crds = bool<br>      org         = string<br>      proj        = string<br>      repo        = string<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
