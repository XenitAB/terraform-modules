## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.25.3 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.13.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | 0.25.3 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.13.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/0.25.3/docs/resources/bootstrap_git) | resource |
| [helm_release.git_auth_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [kubernetes_namespace.git_auth_proxy](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap"></a> [bootstrap](#input\_bootstrap) | Repository configuration to use for bootstrap. | <pre>object({<br>    project    = optional(string)<br>    repository = string<br>  })</pre> | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name of the cluster. | `string` | n/a | yes |
| <a name="input_providers"></a> [providers](#input\_providers) | Git providers for repositories. | <pre>map(object({<br>    organization = string<br>    github_orgs = optional(object({<br>      application_id  = number<br>      installation_id = number<br>      private_key     = string<br>    }))<br>    azure_devops_orgs = optional(object({<br>      pat = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_tenants"></a> [tenants](#input\_tenants) | Flux teanants to add. | <pre>list(<br>    object({<br>      name = string<br>      flux = optional(object({<br>        project     = optional(string)<br>        repository  = string<br>        create_crds = bool<br>      }))<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
