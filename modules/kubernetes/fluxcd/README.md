## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.4.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | 1.4.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/1.4.0/docs/resources/bootstrap_git) | resource |
| [git_repository_file.cluster_tenants](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.tenant](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [helm_release.git_auth_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_namespace.flux_system](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.git_auth_proxy](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap"></a> [bootstrap](#input\_bootstrap) | Repository configuration to use for bootstrap. | <pre>object({<br/>    disable_secret_creation = optional(bool, true)<br/>    project                 = optional(string)<br/>    repository              = string<br/>  })</pre> | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name of the cluster. | `string` | n/a | yes |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider for repositories. | <pre>object({<br/>    organization        = string<br/>    type                = optional(string, "azuredevops")<br/>    github = optional(object({<br/>      application_id  = number<br/>      installation_id = number<br/>      private_key     = string<br/>    }))<br/>    azure_devops = optional(object({<br/>      pat = string<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Flux tenants to add. | <pre>list(<br/>    object({<br/>      name   = string<br/>      labels = optional(map(string), null)<br/>      fluxcd = optional(object({<br/>        provider            = string<br/>        project             = optional(string)<br/>        repository          = string<br/>        include_tenant_name = optional(bool, false)<br/>        create_crds         = optional(bool, true)<br/>      }))<br/>    })<br/>  )</pre> | `[]` | no |

## Outputs

No outputs.
