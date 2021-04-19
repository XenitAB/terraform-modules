# Datadog

Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.

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
| [helm_release.datadog](https://registry.terraform.io/providers/hashicorp/helm/2.1.1/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.1.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key to authenticate to Datadog | `string` | n/a | yes |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | Site to connect Datadog agent | `string` | `"datadoghq.eu"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Cluster environment | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Cluster location | `string` | n/a | yes |

## Outputs

No outputs.
