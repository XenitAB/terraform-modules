## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| aws | 3.20.0 |
| tls | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.20.0 |
| tls | 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| core\_name | The core name for the environment | `string` | n/a | yes |
| eks\_config | The EKS Config | <pre>object({<br>    kubernetes_version = string<br>    cidr_block         = string<br>    node_groups = list(object({<br>      name            = string<br>      release_version = string<br>      min_size        = number<br>      max_size        = number<br>      disk_size       = number<br>      instance_types  = list(string)<br>    }))<br>  })</pre> | n/a | yes |
| eks\_name\_suffix | The suffix for the eks clusters | `number` | `1` | no |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| name | Common name for the environment | `string` | n/a | yes |
| velero\_config | Velero configuration | <pre>object({<br>    s3_bucket_arn = string<br>    s3_bucket_id  = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cert\_manager\_config | Configuration for Cert Manager |
| external\_dns\_config | Configuration for External DNS |
| external\_secrets\_config | Configuration for External DNS |
| kube\_config | Kube config for the created EKS cluster |
| velero\_config | Configuration for Velero |

