# Starboard

Adds [`Starboard`](https://github.com/aquasecurity/starboard) and
[`Trivy`](https://github.com/aquasecurity/trivy) to a Kubernetes clusters.
The modules consists of two components, trivy and starboard where
Trivy is used as a server to store aqua security image vulnerability database.
Staboard is used to trigger image and config scans on newly created replicasets and
generates a CR with a report that both admins and developers can use to improve there setup.

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
| [helm_release.starboard](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.trivy](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_namespace.starboard](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |
| [kubernetes_namespace.trivy](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider used for starboard | `string` | n/a | yes |

## Outputs

No outputs.
