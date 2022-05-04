# Starboard

Adds [`Starboard`](https://github.com/aquasecurity/starboard) and
[`Trivy`](https://github.com/aquasecurity/trivy) to a Kubernetes clusters.
The modules consists of two components, trivy and starboard where
Trivy is used as a server to store aqua security image vulnerability database.
Staboard is used to trigger image and config scans on newly created replicasets and
generates a CR with a report that both admins and developers can use to improve there setup.

[`starboard-exporter`](https://github.com/giantswarm/starboard-exporter) is used to gather
trivy metrics from starboard CRD:s.

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
| [helm_release.starboard](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.starboard_exporter](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.trivy](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.trivy_extras](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubectl_manifest.starboard](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.starboard](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [helm_template.starboard](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/data-sources/template) | data source |
| [kubectl_file_documents.starboard](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Azure specific, the client\_id for aadpodidentity with access to ACR | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider used for starboard | `string` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | Azure specific, the resource\_id for aadpodidentity to the resource | `string` | `""` | no |
| <a name="input_starboard_role_arn"></a> [starboard\_role\_arn](#input\_starboard\_role\_arn) | starboard role arn used to download ECR images, this only applies to AWS | `string` | `""` | no |
| <a name="input_trivy_role_arn"></a> [trivy\_role\_arn](#input\_trivy\_role\_arn) | trivy role arn used to download ECR images, this only applies to AWS | `string` | `""` | no |
| <a name="input_volume_claim_storage_class_name"></a> [volume\_claim\_storage\_class\_name](#input\_volume\_claim\_storage\_class\_name) | StorageClass name that your pvc will use | `string` | `"default"` | no |

## Outputs

No outputs.
