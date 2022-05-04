# Datadog

Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.
This module is built to only gather application data.
API vs APP key.
API is used to send metrics to datadog from the agents.
APP key is used to be able to manage configuration inside datadog like alarms.
https://docs.datadoghq.com/account_management/api-app-keys/

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.datadog_extras](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.datadog_operator](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubectl_manifest.datadog_operator](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [helm_template.datadog_operator](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/data-sources/template) | data source |
| [kubectl_file_documents.datadog_operator](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key to upload data to Datadog | `string` | n/a | yes |
| <a name="input_app_key"></a> [app\_key](#input\_app\_key) | APP key to configure data like alarms in Datadog | `string` | n/a | yes |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | Site to connect Datadog agent | `string` | `"datadoghq.eu"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Cluster environment | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Cluster location | `string` | n/a | yes |
| <a name="input_namespace_include"></a> [namespace\_include](#input\_namespace\_include) | The namespace that should be checked by Datadog, example: kube\_namespace:NAMESPACE kube\_namespace:NAMESPACE2 | `list(string)` | n/a | yes |

## Outputs

No outputs.
