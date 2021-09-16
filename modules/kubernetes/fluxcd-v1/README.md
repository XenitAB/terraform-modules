# Flux (v1)

This module is used to add [`flux`](https://github.com/fluxcd/flux) to Kubernetes clusters.

## Details

The helm chart is added to this module to add the securityContext parameters to the pod running flux, to make sure it works with the `opa-gatekeeper` module.

This module will create a flux instance in each namespace, and not used for fleet-wide configuration.

Will be deprecated as soon as Flux v2 module is finished and tested.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.4.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.azdo_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.fluxcd](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.helm_operator](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_namespace.azdo_proxy](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_secret.azdo_proxy](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/secret) | resource |
| [random_password.azdo_proxy](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_devops_domain"></a> [azure\_devops\_domain](#input\_azure\_devops\_domain) | Domain for azure devops | `string` | `"dev.azure.com"` | no |
| <a name="input_azure_devops_org"></a> [azure\_devops\_org](#input\_azure\_devops\_org) | Azure DevOps organization for bootstrap repository | `string` | n/a | yes |
| <a name="input_azure_devops_pat"></a> [azure\_devops\_pat](#input\_azure\_devops\_pat) | PAT to authenticate with Azure DevOps | `string` | n/a | yes |
| <a name="input_branch"></a> [branch](#input\_branch) | The branch to reconcile manifests from | `string` | `"main"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name of the cluster | `string` | n/a | yes |
| <a name="input_flux_status_enabled"></a> [flux\_status\_enabled](#input\_flux\_status\_enabled) | Should flux status be enabled? | `bool` | `false` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces to configure flux with | <pre>list(<br>    object({<br>      name = string<br>      flux = object({<br>        enabled = bool<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
