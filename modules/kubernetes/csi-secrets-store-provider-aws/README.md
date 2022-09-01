# AWS Key Vault Provider for Secrets Store CSI Driver

Adds [csi-secrets-store-provider-aws](https://github.com/aws/secrets-store-csi-driver-provider-aws) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.6 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.5.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.csi_secrets_store_driver](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.csi_secrets_store_provider_aws](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
