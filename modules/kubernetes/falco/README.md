# Falco

Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.  
The modules consists of two components, the main Falco driver and the sidekick which  
exports events to Datadog.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/2.0.2/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.2/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| datadog\_api\_key | Datadog api key used to authenticate | `string` | n/a | yes |
| datadog\_site | Datadog host to send events to | `string` | `"api.datadoghq.eu"` | no |
| environment | Variable to add to custom fields | `string` | n/a | yes |
| minimum\_priority | Minimum priority required before being exported | `string` | `"INFO"` | no |

## Outputs

No output.
