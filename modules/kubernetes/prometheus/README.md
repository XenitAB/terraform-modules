# Prometheus

Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.
If you are running on AWS we also install [Metrics server](https://aws.amazon.com/premiumsupport/knowledge-center/eks-metrics-server/)

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
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.prometheus_extras](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubectl_manifest.prometheus](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [helm_template.prometheus](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/data-sources/template) | data source |
| [kubectl_file_documents.prometheus](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_pod_identity_enabled"></a> [aad\_pod\_identity\_enabled](#input\_aad\_pod\_identity\_enabled) | Should aad pod dentity be enabled | `bool` | `false` | no |
| <a name="input_aws_config"></a> [aws\_config](#input\_aws\_config) | AWS specific configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | <pre>{<br>  "role_arn": ""<br>}</pre> | no |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br>  })</pre> | <pre>{<br>  "azure_key_vault_name": "",<br>  "identity": {<br>    "client_id": "",<br>    "resource_id": "",<br>    "tenant_id": ""<br>  }<br>}</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Name of cloud provider | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the prometheus cluster | `string` | n/a | yes |
| <a name="input_csi_secrets_store_provider_aws_enabled"></a> [csi\_secrets\_store\_provider\_aws\_enabled](#input\_csi\_secrets\_store\_provider\_aws\_enabled) | Should csi-secrets-store-provider-aws be enabled | `bool` | `false` | no |
| <a name="input_csi_secrets_store_provider_azure_enabled"></a> [csi\_secrets\_store\_provider\_azure\_enabled](#input\_csi\_secrets\_store\_provider\_azure\_enabled) | Should csi-secrets-store-provider-azure be enabled | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment in which the prometheus instance is deployed | `string` | n/a | yes |
| <a name="input_falco_enabled"></a> [falco\_enabled](#input\_falco\_enabled) | Should Falco be enabled | `bool` | `false` | no |
| <a name="input_flux_enabled"></a> [flux\_enabled](#input\_flux\_enabled) | Should flux-system be enabled | `bool` | `false` | no |
| <a name="input_grafana_agent_enabled"></a> [grafana\_agent\_enabled](#input\_grafana\_agent\_enabled) | Should grafana-agent be enabled | `bool` | `false` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_namespace_selector"></a> [namespace\_selector](#input\_namespace\_selector) | Kind labels to look for in namespaces | `list(string)` | <pre>[<br>  "platform"<br>]</pre> | no |
| <a name="input_node_local_dns_enabled"></a> [node\_local\_dns\_enabled](#input\_node\_local\_dns\_enabled) | Should node local DNS be enabled | `bool` | `false` | no |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `false` | no |
| <a name="input_promtail_enabled"></a> [promtail\_enabled](#input\_promtail\_enabled) | Should promtail be enabled | `bool` | `false` | no |
| <a name="input_remote_write_authenticated"></a> [remote\_write\_authenticated](#input\_remote\_write\_authenticated) | Adds TLS authentication to remote write configuration if true | `bool` | `true` | no |
| <a name="input_remote_write_url"></a> [remote\_write\_url](#input\_remote\_write\_url) | The URL where to send prometheus remote\_write data | `string` | n/a | yes |
| <a name="input_resource_selector"></a> [resource\_selector](#input\_resource\_selector) | Monitoring type labels to look for in Prometheus resources | `list(string)` | <pre>[<br>  "platform"<br>]</pre> | no |
| <a name="input_starboard_enabled"></a> [starboard\_enabled](#input\_starboard\_enabled) | Should starboard be enabled | `bool` | `false` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The tenant id label to apply to all metrics in remote write | `string` | `""` | no |
| <a name="input_volume_claim_size"></a> [volume\_claim\_size](#input\_volume\_claim\_size) | Size of prometheus disk | `string` | `"10Gi"` | no |
| <a name="input_volume_claim_storage_class_name"></a> [volume\_claim\_storage\_class\_name](#input\_volume\_claim\_storage\_class\_name) | StorageClass name that your pvc will use | `string` | `"default"` | no |
| <a name="input_vpa_enabled"></a> [vpa\_enabled](#input\_vpa\_enabled) | Should vpa be enabled | `bool` | `false` | no |

## Outputs

No outputs.
