# Prometheus

Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.

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
| remote\_write\_enabled | If remote write should be enabled or not | `bool` | `true` | no |
| remote\_write\_name | The name of the remote write in prometheus | `string` | `"xenitInfra"` | no |
| remote\_write\_url | The URL where to send prometheus remote\_write data | `string` | n/a | yes |
| volume\_claim\_enabled | If prometheus should store data localy | `bool` | `true` | no |
| volume\_claim\_size | Size of prometheus disk | `string` | `"5Gi"` | no |
| volume\_claim\_storage\_class\_name | StorageClass name that your pvc will use | `string` | `"default"` | no |

## Outputs

No output.
