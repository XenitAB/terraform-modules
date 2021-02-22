## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 2.0.2 |
| kubernetes | 2.0.2 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/2.0.2/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.2/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| excluded\_namespaces | Namespaces to exclude from mutating hooks | `list(string)` | n/a | yes |

## Outputs

No output.
