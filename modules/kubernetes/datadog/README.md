# Datadog

Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 1.3.2 |
| kubernetes | 1.13.3 |

## Providers

| Name | Version |
|------|---------|
| helm | 1.3.2 |
| kubernetes | 1.13.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_key | API key to authenticate to Datadog | `string` | n/a | yes |
| datadog\_site | Site to connect Datadog agent | `string` | `"datadoghq.eu"` | no |
| environment | Cluster environment | `string` | n/a | yes |
| input\_depends\_on | Input dependency for module | `any` | `{}` | no |
| location | Cluster location | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| output\_depends\_on | Output dependency for module |

