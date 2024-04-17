# Velero

This module is used to add [`velero`](https://github.com/vmware-tanzu/velero) to Kubernetes clusters.

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
| [helm_release.velero](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [helm_release.velero_extras](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    subscription_id           = string,<br>    resource_group            = string,<br>    client_id                 = string,<br>    resource_id               = string,<br>    storage_account_name      = string,<br>    storage_account_container = string<br>  })</pre> | <pre>{<br>  "client_id": "",<br>  "resource_group": "",<br>  "resource_id": "",<br>  "storage_account_container": "",<br>  "storage_account_name": "",<br>  "subscription_id": "",<br>  "tenant_id": ""<br>}</pre> | no |

## Outputs

No outputs.
