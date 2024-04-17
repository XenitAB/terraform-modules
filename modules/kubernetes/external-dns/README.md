# External DNS (external-dns)

This module is used to add [`external-dns`](https://github.com/kubernetes-sigs/external-dns) to Kubernetes clusters.

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
| [git_repository_file.external_dns](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    subscription_id = string,<br>    tenant_id       = string,<br>    resource_group  = string,<br>    client_id       = string,<br>  })</pre> | <pre>{<br>  "client_id": "",<br>  "resource_group": "",<br>  "subscription_id": "",<br>  "tenant_id": ""<br>}</pre> | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_dns_provider"></a> [dns\_provider](#input\_dns\_provider) | DNS provider to use. | `string` | n/a | yes |
| <a name="input_sources"></a> [sources](#input\_sources) | k8s resource types to observe | `list(string)` | <pre>[<br>  "ingress",<br>  "service"<br>]</pre> | no |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | The txt-owner-id for external-dns | `string` | n/a | yes |

## Outputs

No outputs.
