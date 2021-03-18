# Datadog

Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.7 |
| helm | 2.0.3 |
| kubernetes | 2.0.3 |

## Providers

| Name | Version |
|------|---------|
| helm | 2.0.3 |
| kubernetes | 2.0.3 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/2.0.3/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.3/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_key | API key to authenticate to Datadog | `string` | n/a | yes |
| datadog\_site | Site to connect Datadog agent | `string` | `"datadoghq.eu"` | no |
| environment | Cluster environment | `string` | n/a | yes |
| location | Cluster location | `string` | n/a | yes |

## Outputs

No output.
