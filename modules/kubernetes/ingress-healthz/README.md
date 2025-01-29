# Ingress Healthz (ingress-healthz)

This module is used to deploy a very simple NGINX server meant to check the health of cluster ingress.
It is meant to simulate an application that expects traffic through the ingress controller with
automatic DNS creation and certificate creation, without depending on the stability of a dynamic application.

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
| [git_repository_file.ingress_healthz](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | DNS Zone to create ingress sub domain under | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment ingress-healthz is deployed in | `string` | n/a | yes |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Region short name | `string` | `""` | no |

## Outputs

No outputs.
