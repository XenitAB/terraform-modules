# Xenit Platform Configuration

This module is used to add Xenit Kubernetes Framework configuration to Kubernetes clusters.

You need to configure a certificate in Azure KeyVault
```shell
openssl pkcs12 -export -in tenant-xenit-proxy.crt -inkey tenant-xenit-proxy.key -out tenant-xenit-proxy.pfx
az keyvault certificate import --vault-name <aks keyvault name> -n xenit-proxy-certificate -f tenant-xenit-proxy.pfx
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.1.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.1.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.xenit_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.1.2/docs/resources/release) | resource |
| [helm_release.xenit_proxy_extras](https://registry.terraform.io/providers/hashicorp/helm/2.1.2/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.3.1/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration | <pre>object({<br>    azure_key_vault_name = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>      tenant_id   = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_loki_api_fqdn"></a> [loki\_api\_fqdn](#input\_loki\_api\_fqdn) | The loki api fqdn | `string` | n/a | yes |
| <a name="input_thanos_receiver_fqdn"></a> [thanos\_receiver\_fqdn](#input\_thanos\_receiver\_fqdn) | The thanos receiver fqdn | `string` | n/a | yes |

## Outputs

No outputs.
