# New Relic

This module is used to install [`New Relic`](https://github.com/newrelic/helm-charts) in a Kubernetes cluster.

## Details

New Relic monitoring is an alternative to Datadog for end users. It works very much in a similar way, running exporters on all nodes and exporting data. The exporter is meant to be configured for
specific namespaces so that all metrics in the cluster are not exported. Check the [New Relic Kubernetes
Documentation](https://docs.newrelic.com/docs/integrations/kubernetes-integration/installation/kubernetes-integration-install-configure/) for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.6.1/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster to use in New Relic | `string` | n/a | yes |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | License key used to authenticate with New Relic | `string` | n/a | yes |
| <a name="input_namespace_include"></a> [namespace\_include](#input\_namespace\_include) | The namespace that should be included in New Relic metrics and logs | `list(string)` | n/a | yes |

## Outputs

No outputs.
