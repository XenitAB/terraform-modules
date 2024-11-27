# Azure AD Kubernetes API Proxy
Adds [`azad-kube-proxy`](https://github.com/XenitAB/azad-kube-proxy) to a Kubernetes clusters.

# Terraform example (aks-core)

module "aks\_core" {
  source = "github.com/xenitab/terraform-modules//modules/kubernetes/aks-core?ref=[ref]"

  [...]

  azad\_kube\_proxy\_enabled = true
  azad\_kube\_proxy\_config = {
    fqdn                  = "aks.${var.dns\_zone}"
    azure\_ad\_group\_prefix = var.aks\_group\_name\_prefix
    allowed\_ips           = var.aks\_authorized\_ips
    azure\_ad\_app          = module.aks\_global.azad\_kube\_proxy.azure\_ad\_app
  }
}
```
```

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azad_kube_proxy"></a> [azad\_kube\_proxy](#module\_azad\_kube\_proxy) | ../../azure-ad/azad-kube-proxy | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.azad_kube_proxy](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault_access_policy.azad_kube_proxy](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.azad_kube_proxy](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/key_vault_secret) | resource |
| [azurerm_user_assigned_identity.azad_kube_proxy](https://registry.terraform.io/providers/hashicorp/azurerm/4.7.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.azad_kube_proxy](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.azure_config](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.kustomization](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | The external IPs allowed through the ingress to azad-kube-proxy | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_azad_kube_proxy_config"></a> [azad\_kube\_proxy\_config](#input\_azad\_kube\_proxy\_config) | Azure AD Kubernetes Proxy configuration | <pre>object({<br/>    cluster_name_prefix = string<br/>    proxy_url_override  = string<br/>  })</pre> | <pre>{<br/>  "cluster_name_prefix": "aks",<br/>  "proxy_url_override": ""<br/>}</pre> | no |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | The Azure AD group prefix to filter for | `string` | `""` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | List of DNS Zones | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | The name to use with the ingress (fully qualified domain name). Example: k8s.example.com | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | core keyvault id | `string` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The keyvault name. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the deploy | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_private_ingress_enabled"></a> [private\_ingress\_enabled](#input\_private\_ingress\_enabled) | If true will create a public and private ingress controller. Otherwise only a public ingress controller will be created. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_use_private_ingress"></a> [use\_private\_ingress](#input\_use\_private\_ingress) | If true, private ingress will be used by azad-kube-proxy | `bool` | `false` | no |

## Outputs

No outputs.

