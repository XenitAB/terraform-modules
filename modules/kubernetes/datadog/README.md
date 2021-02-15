# Datadog

Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_key | API key to authenticate to Datadog | `string` | n/a | yes |
| datadog\_site | Site to connect Datadog agent | `string` | `"datadoghq.eu"` | no |
| environment | Cluster environment | `string` | n/a | yes |
| location | Cluster location | `string` | n/a | yes |

## Outputs

No output.

