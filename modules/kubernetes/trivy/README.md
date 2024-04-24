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
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.starboard_eporter](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.trivy](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.trivy_extras](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.trivy_operator](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Azure specific, the client\_id for aadpodidentity with access to ACR | `string` | `""` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | Azure specific, the resource\_id for aadpodidentity to the resource | `string` | `""` | no |
| <a name="input_starboard_exporter_enabled"></a> [starboard\_exporter\_enabled](#input\_starboard\_exporter\_enabled) | If the starboard-exporter Helm chart should be deployed | `bool` | `true` | no |
| <a name="input_volume_claim_storage_class_name"></a> [volume\_claim\_storage\_class\_name](#input\_volume\_claim\_storage\_class\_name) | StorageClass name that your pvc will use | `string` | `"default"` | no |

## Outputs

No outputs.
