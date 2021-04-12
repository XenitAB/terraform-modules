# Ingress Healthz (ingress-healthz)

This module is used to add [`ingress-healthz`](https://github.com/XenitAB/ingress-healthz) to Kubernetes clusters.

Ingress Healthz is used to test and measure access to the cluster, it has no other functional value. It is meant
to simulate an application that expects traffic through the ingress controller with automatic DNS creation and
certificate creation, without depending on the stability of a dynamic application.

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
| [helm_release.ingress_healthz](https://registry.terraform.io/providers/hashicorp/helm/2.0.3/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.3/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | DNS Zone to create ingress sub domain under | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment ingress-healthz is deployed in | `string` | n/a | yes |

## Outputs

No outputs.
