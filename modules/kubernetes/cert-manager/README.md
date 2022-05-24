# Certificate manager (cert-manager)

This module is used to add [`cert-manager`](https://github.com/jetstack/cert-manager) to Kubernetes clusters.

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
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.cert_manager_extras](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubectl_manifest.cert_manager](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [helm_template.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/data-sources/template) | data source |
| [kubectl_file_documents.cert_manager](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acme_server"></a> [acme\_server](#input\_acme\_server) | ACME server to add to the created ClusterIssuer | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_aws_config"></a> [aws\_config](#input\_aws\_config) | AWS specific configuration | <pre>object({<br>    region         = string,<br>    hosted_zone_id = map(string)<br>    role_arn       = string,<br>  })</pre> | <pre>{<br>  "hosted_zone_id": {},<br>  "region": "",<br>  "role_arn": ""<br>}</pre> | no |
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    subscription_id     = string,<br>    hosted_zone_names   = list(string),<br>    resource_group_name = string,<br>    client_id           = string,<br>    resource_id         = string,<br>  })</pre> | <pre>{<br>  "client_id": "",<br>  "hosted_zone_names": [],<br>  "resource_group_name": "",<br>  "resource_id": "",<br>  "subscription_id": ""<br>}</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider to use. | `string` | n/a | yes |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address to send certificate expiration notifications | `string` | n/a | yes |

## Outputs

No outputs.
