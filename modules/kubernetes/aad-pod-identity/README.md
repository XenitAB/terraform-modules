# Azure AD POD Identity (AAD-POD-Identity)

This module is used to add [`aad-pod-identity`](https://github.com/Azure/aad-pod-identity) to Kubernetes clusters (tested with AKS).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.aad_pod_identity](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_pod_identity"></a> [aad\_pod\_identity](#input\_aad\_pod\_identity) | Configuration for aad pod identity | <pre>map(object({<br/>    id        = string<br/>    client_id = string<br/>  }))</pre> | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Namespaces to create AzureIdentity and AzureIdentityBindings in. | <pre>list(<br/>    object({<br/>      name = string<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
