# Trivy

Adds [`Trivy-operator`](https://github.com/aquasecurity/trivy-operator) and
[`Trivy`](https://github.com/aquasecurity/trivy) to a Kubernetes clusters.
The modules consists of two components, trivy and trivy-operator where
Trivy is used as a server to store aqua security image vulnerability database.
Trivy-operator is used to trigger image and config scans on newly created replicasets and
generates a CR with a report that both admins and developers can use to improve there setup.

[`starboard-exporter`](https://github.com/giantswarm/starboard-exporter) is used to gather
trivy metrics from trivy-operator CRD:s.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.starboard_exporter](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.trivy_extras](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [helm_release.trivy_operator](https://registry.terraform.io/providers/hashicorp/helm/2.6.0/docs/resources/release) | resource |
| [kubernetes_namespace.trivy](https://registry.terraform.io/providers/hashicorp/kubernetes/2.13.1/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Azure specific, the client\_id for aadpodidentity with access to ACR | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider used for trivy | `string` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | Azure specific, the resource\_id for aadpodidentity to the resource | `string` | `""` | no |
| <a name="input_trivy_operator_role_arn"></a> [trivy\_operator\_role\_arn](#input\_trivy\_operator\_role\_arn) | trivy-operaetor role arn used to download ECR images, this only applies to AWS | `string` | `""` | no |
| <a name="input_volume_claim_storage_class_name"></a> [volume\_claim\_storage\_class\_name](#input\_volume\_claim\_storage\_class\_name) | StorageClass name that your pvc will use | `string` | `"default"` | no |

## Outputs

No outputs.
