# EKS Core

This module is used to configure EKS clusters.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.14.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.39.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 0.1.4 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.9.3 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.10.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.39.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../../kubernetes/cert-manager |  |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../kubernetes/external-dns |  |
| <a name="module_external_secrets"></a> [external\_secrets](#module\_external\_secrets) | ../../kubernetes/external-secrets |  |
| <a name="module_fluxcd_v2_github"></a> [fluxcd\_v2\_github](#module\_fluxcd\_v2\_github) | ../../kubernetes/fluxcd-v2-github |  |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | ../../kubernetes/ingress-nginx |  |
| <a name="module_kyverno"></a> [kyverno](#module\_kyverno) | ../../kubernetes/kyverno |  |
| <a name="module_opa_gatekeeper"></a> [opa\_gatekeeper](#module\_opa\_gatekeeper) | ../../kubernetes/opa-gatekeeper |  |
| <a name="module_velero"></a> [velero](#module\_velero) | ../../kubernetes/velero |  |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.1.0/docs/resources/namespace) | resource |
| [kubernetes_network_policy.tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/2.1.0/docs/resources/network_policy) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.39.0/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/3.39.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_config"></a> [cert\_manager\_config](#input\_cert\_manager\_config) | Cert Manager configuration | <pre>object({<br>    notification_email = string<br>    dns_zone           = string<br>    role_arn           = string<br>  })</pre> | n/a | yes |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Should Cert Manager be enabled | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_external_dns_config"></a> [external\_dns\_config](#input\_external\_dns\_config) | External DNS configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Should External DNS be enabled | `bool` | `true` | no |
| <a name="input_external_secrets_config"></a> [external\_secrets\_config](#input\_external\_secrets\_config) | External Secrets configuration | <pre>object({<br>    role_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_external_secrets_enabled"></a> [external\_secrets\_enabled](#input\_external\_secrets\_enabled) | Should External Secrets be enabled | `bool` | `true` | no |
| <a name="input_fluxcd_v2_config"></a> [fluxcd\_v2\_config](#input\_fluxcd\_v2\_config) | Configuration for fluxcd-v2 | <pre>object({<br>    type = string<br>    github = object({<br>      owner = string<br>    })<br>    azure_devops = object({<br>      pat  = string<br>      org  = string<br>      proj = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_fluxcd_v2_enabled"></a> [fluxcd\_v2\_enabled](#input\_fluxcd\_v2\_enabled) | Should fluxcd-v2 be enabled | `bool` | `true` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Should Ingress NGINX be enabled | `bool` | `true` | no |
| <a name="input_kubernetes_network_policy_default_deny"></a> [kubernetes\_network\_policy\_default\_deny](#input\_kubernetes\_network\_policy\_default\_deny) | If network policies should by default deny cross namespace traffic | `bool` | `false` | no |
| <a name="input_kyverno_enabled"></a> [kyverno\_enabled](#input\_kyverno\_enabled) | Should Kyverno be enabled | `bool` | `true` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name   = string<br>      labels = map(string)<br>      flux = object({<br>        enabled = bool<br>        github = object({<br>          repo = string<br>        })<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_opa_gatekeeper_enabled"></a> [opa\_gatekeeper\_enabled](#input\_opa\_gatekeeper\_enabled) | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Velero configuration | <pre>object({<br>    role_arn     = string<br>    s3_bucket_id = string<br>  })</pre> | n/a | yes |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Should Velero be enabled | `bool` | `false` | no |

## Outputs

No outputs.
