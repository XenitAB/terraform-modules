# Azure AD POD Identity (AAD-POD-Identity)

This module is used to add [`aad-pod-identity`](https://github.com/Azure/aad-pod-identity) to Kubernetes clusters (tested with AKS).

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
| [helm_release.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubectl_manifest.aad_pod_identity](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [helm_template.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/data-sources/template) | data source |
| [kubectl_file_documents.aad_pod_identity](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_pod_identity"></a> [aad\_pod\_identity](#input\_aad\_pod\_identity) | Configuration for aad pod identity | <pre>map(object({<br>    id        = string<br>    client_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Namespaces to create AzureIdentity and AzureIdentityBindings in. | <pre>list(<br>    object({<br>      name = string<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
