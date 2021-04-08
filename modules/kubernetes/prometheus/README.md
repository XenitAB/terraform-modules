# Prometheus

Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.14.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.0.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.0.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/2.0.3/docs/resources/release) | resource |
| [helm_release.prometheus_extras](https://registry.terraform.io/providers/hashicorp/helm/2.0.3/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.3/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alertmanager_enabled"></a> [alertmanager\_enabled](#input\_alertmanager\_enabled) | If prometheus alertmanager should be enabled or not | `bool` | `false` | no |
| <a name="input_remote_tls_secret_name"></a> [remote\_tls\_secret\_name](#input\_remote\_tls\_secret\_name) | The secret name of tls for remote write | `string` | `"client-certificate"` | no |
| <a name="input_remote_write_enabled"></a> [remote\_write\_enabled](#input\_remote\_write\_enabled) | If remote write should be enabled or not | `bool` | `true` | no |
| <a name="input_remote_write_name"></a> [remote\_write\_name](#input\_remote\_write\_name) | The name of the remote write in prometheus | `string` | `"xenitInfra"` | no |
| <a name="input_remote_write_url"></a> [remote\_write\_url](#input\_remote\_write\_url) | The URL where to send prometheus remote\_write data | `string` | n/a | yes |
| <a name="input_volume_claim_enabled"></a> [volume\_claim\_enabled](#input\_volume\_claim\_enabled) | If prometheus should store data localy | `bool` | `true` | no |
| <a name="input_volume_claim_size"></a> [volume\_claim\_size](#input\_volume\_claim\_size) | Size of prometheus disk | `string` | `"5Gi"` | no |
| <a name="input_volume_claim_storage_class_name"></a> [volume\_claim\_storage\_class\_name](#input\_volume\_claim\_storage\_class\_name) | StorageClass name that your pvc will use | `string` | `"default"` | no |

## Outputs

No outputs.
