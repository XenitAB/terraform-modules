## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.50.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.50.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.dex](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application) | resource |
| [azuread_application_password.dex](https://registry.terraform.io/providers/hashicorp/azuread/2.50.0/docs/resources/application_password) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_namespace.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_config"></a> [argocd\_config](#input\_argocd\_config) | ArgoCD configuration | <pre>object({<br/>    application_set_replicas = optional(number, 2)<br/>    controller_min_replicas  = optional(number, 1)<br/>    repo_server_min_replicas = optional(number, 2)<br/>    server_min_replicas      = optional(number, 2)<br/>    redis_enabled            = optional(bool, true)<br/>    global_domain            = string<br/>    ingress_whitelist_ip     = string<br/>    tenant                   = string<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
