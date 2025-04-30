# Telepresence

Adds [`Telepresence`](https://github.com/telepresenceio/telepresence) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.telepresence](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_telepresence_config"></a> [telepresence\_config](#input\_telepresence\_config) | Config to use when deploying traffic manager to the cluster | <pre>object({<br/>    allow_conflicting_subnets = optional(list(string), [])<br/>    client_rbac = object({<br/>      create     = bool<br/>      namespaced = bool<br/>      namespaces = optional(list(string), ["ambassador"])<br/>      subjects   = optional(list(string), [])<br/>    })<br/>    manager_rbac = object({<br/>      create     = bool<br/>      namespaced = bool<br/>      namespaces = optional(list(string), [])<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
