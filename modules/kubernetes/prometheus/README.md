# Prometheus

Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.
If you are running on AWS we also install [Metrics server](https://aws.amazon.com/premiumsupport/knowledge-center/eks-metrics-server/)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.prometheus_extras](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_pod_identity_enabled"></a> [aad\_pod\_identity\_enabled](#input\_aad\_pod\_identity\_enabled) | Should aad pod dentity be enabled | `bool` | `false` | no |
| <a name="input_alertmanager_enabled"></a> [alertmanager\_enabled](#input\_alertmanager\_enabled) | If alertmanager should be setup or not | `bool` | `false` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider to use. | `string` | `"azure"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the prometheus cluster | `string` | n/a | yes |
| <a name="input_csi_secrets_store_provider_aws_enabled"></a> [csi\_secrets\_store\_provider\_aws\_enabled](#input\_csi\_secrets\_store\_provider\_aws\_enabled) | Should csi-secrets-store-provider-aws be enabled | `bool` | `false` | no |
| <a name="input_csi_secrets_store_provider_azure_enabled"></a> [csi\_secrets\_store\_provider\_azure\_enabled](#input\_csi\_secrets\_store\_provider\_azure\_enabled) | Should csi-secrets-store-provider-azure be enabled | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment in which the prometheus instance is deployed | `string` | n/a | yes |
| <a name="input_falco_enabled"></a> [falco\_enabled](#input\_falco\_enabled) | Should Falco be enabled | `bool` | `false` | no |
| <a name="input_flux_system_enabled"></a> [flux\_system\_enabled](#input\_flux\_system\_enabled) | Should flux-system be enabled | `bool` | `false` | no |
| <a name="input_goldpinger_enabled"></a> [goldpinger\_enabled](#input\_goldpinger\_enabled) | Should goldpinger be enabled | `bool` | `false` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_namespace_selector"></a> [namespace\_selector](#input\_namespace\_selector) | Kind labels to look for in namespaces | `list(string)` | <pre>[<br>  "platform"<br>]</pre> | no |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `false` | no |
| <a name="input_remote_write_enabled"></a> [remote\_write\_enabled](#input\_remote\_write\_enabled) | If remote write should be enabled or not | `bool` | `true` | no |
| <a name="input_remote_write_url"></a> [remote\_write\_url](#input\_remote\_write\_url) | The URL where to send prometheus remote\_write data | `string` | n/a | yes |
| <a name="input_resource_selector"></a> [resource\_selector](#input\_resource\_selector) | Monitoring type labels to look for in Prometheus resources | `list(string)` | <pre>[<br>  "platform"<br>]</pre> | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The tenant id label to apply to all metrics in remote write | `string` | `""` | no |
| <a name="input_volume_claim_enabled"></a> [volume\_claim\_enabled](#input\_volume\_claim\_enabled) | If prometheus should store data localy | `bool` | `true` | no |
| <a name="input_volume_claim_size"></a> [volume\_claim\_size](#input\_volume\_claim\_size) | Size of prometheus disk | `string` | `"5Gi"` | no |
| <a name="input_volume_claim_storage_class_name"></a> [volume\_claim\_storage\_class\_name](#input\_volume\_claim\_storage\_class\_name) | StorageClass name that your pvc will use | `string` | `"default"` | no |

## Outputs

No outputs.
