# Contour

This module is used to add [`Contour`](https://projectcontour.io/) to Kubernetes clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.contour](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [kubernetes_namespace.contour](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_contour_config"></a> [contour\_config](#input\_contour\_config) | Contour configuration | <pre>object({<br/>    ingress_enabled = optional(bool, true)<br/>    replica_count   = optional(number, 2)<br/>    resource_preset = optional(string, "small")<br/>  })</pre> | n/a | yes |
| <a name="input_envoy_config"></a> [envoy\_config](#input\_envoy\_config) | Contour configuration | <pre>object({<br/>    log_level       = optional(string, "info")<br/>    replica_count   = optional(number, 2)<br/>    resource_preset = optional(string, "small")<br/>    hpa_enabled     = optional(bool, false)<br/>    hpa_config = optional(object({<br/>      max_replicas  = number<br/>      maz_cpu       = optional(string, null)<br/>      target_memory = optional(string, null)<br/>      behavior      = optional(string, null)<br/>    }))<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
