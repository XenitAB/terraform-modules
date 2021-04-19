# Falco

Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
The modules consists of two components, the main Falco driver and the sidekick which
exports events to Datadog.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.14.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.1.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.falco](https://registry.terraform.io/providers/hashicorp/helm/2.1.1/docs/resources/release) | resource |
| [helm_release.falcosidekick](https://registry.terraform.io/providers/hashicorp/helm/2.1.1/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.1.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog api key used to authenticate | `string` | n/a | yes |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | Datadog host to send events to | `string` | `"api.datadoghq.eu"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Variable to add to custom fields | `string` | n/a | yes |
| <a name="input_minimum_priority"></a> [minimum\_priority](#input\_minimum\_priority) | Minimum priority required before being exported | `string` | `"INFO"` | no |

## Outputs

No outputs.
