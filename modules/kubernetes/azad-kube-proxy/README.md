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
| [helm_release.azad_kube_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [kubernetes_secret.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | The external IPs allowed through the ingress to azad-kube-proxy | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_azure_ad_app"></a> [azure\_ad\_app](#input\_azure\_ad\_app) | The Azure AD Application config for azad-kube-proxy | <pre>object({<br>    client_id     = string<br>    client_secret = string<br>    tenant_id     = string<br>  })</pre> | n/a | yes |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | The Azure AD group prefix to filter for | `string` | `""` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | The name to use with the ingress (fully qualified domain name). Example: k8s.example.com | `string` | n/a | yes |

## Outputs

No outputs.
