# Prometheus

Adds [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.7.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.7.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.prometheus](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/federated_identity_credential) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.monitors](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.prometheus](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.prometheus_operator](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.rbac](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.secret_provider_class](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.x509_certificate_exporter](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [azurerm_user_assigned_identity.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_pod_identity_enabled"></a> [aad\_pod\_identity\_enabled](#input\_aad\_pod\_identity\_enabled) | Should aad pod dentity be enabled | `bool` | `false` | no |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | The AKS cluster short name, e.g. 'aks'. | `string` | n/a | yes |
| <a name="input_azad_kube_proxy_enabled"></a> [azad\_kube\_proxy\_enabled](#input\_azad\_kube\_proxy\_enabled) | Should azad-kube-proxy be enabled | `bool` | `false` | no |
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br/>    azure_key_vault_name = string<br/>  })</pre> | <pre>{<br/>  "azure_key_vault_name": ""<br/>}</pre> | no |
| <a name="input_cilium_enabled"></a> [cilium\_enabled](#input\_cilium\_enabled) | If enabled, will use Azure CNI with Cilium instead of kubenet | `bool` | `false` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the prometheus cluster | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment in which the prometheus instance is deployed | `string` | n/a | yes |
| <a name="input_falco_enabled"></a> [falco\_enabled](#input\_falco\_enabled) | Should Falco be enabled | `bool` | `false` | no |
| <a name="input_flux_enabled"></a> [flux\_enabled](#input\_flux\_enabled) | Should flux-system be enabled | `bool` | `false` | no |
| <a name="input_gatekeeper_enabled"></a> [gatekeeper\_enabled](#input\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `false` | no |
| <a name="input_grafana_agent_enabled"></a> [grafana\_agent\_enabled](#input\_grafana\_agent\_enabled) | Should grafana-agent be enabled | `bool` | `false` | no |
| <a name="input_linkerd_enabled"></a> [linkerd\_enabled](#input\_linkerd\_enabled) | Should linkerd be enabled | `bool` | `false` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_namespace_selector"></a> [namespace\_selector](#input\_namespace\_selector) | Kind labels to look for in namespaces | `list(string)` | <pre>[<br/>  "platform"<br/>]</pre> | no |
| <a name="input_node_local_dns_enabled"></a> [node\_local\_dns\_enabled](#input\_node\_local\_dns\_enabled) | Should node local DNS be enabled | `bool` | `false` | no |
| <a name="input_node_ttl_enabled"></a> [node\_ttl\_enabled](#input\_node\_ttl\_enabled) | Should Node TTL be enabled | `bool` | `false` | no |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_promtail_enabled"></a> [promtail\_enabled](#input\_promtail\_enabled) | Should promtail be enabled | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which the prometheus instance is deployed | `string` | n/a | yes |
| <a name="input_remote_write_authenticated"></a> [remote\_write\_authenticated](#input\_remote\_write\_authenticated) | Adds TLS authentication to remote write configuration if true | `bool` | `true` | no |
| <a name="input_remote_write_url"></a> [remote\_write\_url](#input\_remote\_write\_url) | The URL where to send prometheus remote\_write data | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_resource_selector"></a> [resource\_selector](#input\_resource\_selector) | Monitoring type labels to look for in Prometheus resources | `list(string)` | <pre>[<br/>  "platform"<br/>]</pre> | no |
| <a name="input_spegel_enabled"></a> [spegel\_enabled](#input\_spegel\_enabled) | Should Spegel be enabled | `bool` | `false` | no |
| <a name="input_trivy_enabled"></a> [trivy\_enabled](#input\_trivy\_enabled) | Should trivy be enabled | `bool` | `false` | no |
| <a name="input_volume_claim_size"></a> [volume\_claim\_size](#input\_volume\_claim\_size) | Size of prometheus disk | `string` | `"10Gi"` | no |
| <a name="input_volume_claim_storage_class_name"></a> [volume\_claim\_storage\_class\_name](#input\_volume\_claim\_storage\_class\_name) | StorageClass name that your pvc will use | `string` | `"default"` | no |
| <a name="input_vpa_enabled"></a> [vpa\_enabled](#input\_vpa\_enabled) | Should vpa be enabled | `bool` | `false` | no |

## Outputs

No outputs.
