## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.9.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.9.0 |
| <a name="provider_aws.eks_admin"></a> [aws.eks\_admin](#provider\_aws.eks\_admin) | 4.9.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../irsa | n/a |
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | ../irsa | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../irsa | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ../irsa | n/a |
| <a name="module_promtail"></a> [promtail](#module\_promtail) | ../irsa | n/a |
| <a name="module_starboard_ecr"></a> [starboard\_ecr](#module\_starboard\_ecr) | ../irsa | n/a |
| <a name="module_trivy_ecr"></a> [trivy\_ecr](#module\_trivy\_ecr) | ../irsa | n/a |
| <a name="module_velero"></a> [velero](#module\_velero) | ../irsa | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.core_dns](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_launch_template.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/resources/launch_template) | resource |
| [null_resource.update_eks_cni](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_addon_version.core_dns](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.cert_manager](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.starboard_ecr_read_only](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.velero](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.xenit_proxy_certificate](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/region) | data source |
| [aws_subnet.cluster](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/subnet) | data source |
| [aws_subnet.node](https://registry.terraform.io/providers/hashicorp/aws/4.9.0/docs/data-sources/subnet) | data source |
| [tls_certificate.thumbprint](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | eks secrets customer master key | `string` | n/a | yes |
| <a name="input_cluster_role_arn"></a> [cluster\_role\_arn](#input\_cluster\_role\_arn) | IAM role to attach to EKS cluster | `string` | n/a | yes |
| <a name="input_eks_authorized_ips"></a> [eks\_authorized\_ips](#input\_eks\_authorized\_ips) | Authorized IPs to access EKS API | `list(string)` | n/a | yes |
| <a name="input_eks_config"></a> [eks\_config](#input\_eks\_config) | The EKS Config | <pre>object({<br>    version    = string<br>    cidr_block = string<br>    node_pools = list(object({<br>      name           = string<br>      version        = string<br>      instance_types = list(string)<br>      min_size       = number<br>      max_size       = number<br>      node_labels    = map(string)<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_eks_name_suffix"></a> [eks\_name\_suffix](#input\_eks\_name\_suffix) | The suffix for the eks clusters | `number` | `1` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | Which EKS controller logs should be saved | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Common name for the environment | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix to add to unique names such as S3 buckets and IAM roles | `string` | `"xks"` | no |
| <a name="input_node_group_role_arn"></a> [node\_group\_role\_arn](#input\_node\_group\_role\_arn) | IAM role to attach to EKS node groups | `string` | n/a | yes |
| <a name="input_starboard_enabled"></a> [starboard\_enabled](#input\_starboard\_enabled) | Should starboard be enaled | `bool` | `false` | no |
| <a name="input_velero_config"></a> [velero\_config](#input\_velero\_config) | Configuration for Velero | <pre>object({<br>    s3_bucket_id  = string<br>    s3_bucket_arn = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_config"></a> [cert\_manager\_config](#output\_cert\_manager\_config) | Configuration for Cert Manager |
| <a name="output_cluster_autoscaler_config"></a> [cluster\_autoscaler\_config](#output\_cluster\_autoscaler\_config) | Configuration for Cluster Autoscaler |
| <a name="output_external_dns_config"></a> [external\_dns\_config](#output\_external\_dns\_config) | Configuration for External DNS |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kube config for the created EKS cluster |
| <a name="output_prometheus_config"></a> [prometheus\_config](#output\_prometheus\_config) | Configuration for Prometheus |
| <a name="output_promtail_config"></a> [promtail\_config](#output\_promtail\_config) | Configuration for Promtail |
| <a name="output_starboard_config"></a> [starboard\_config](#output\_starboard\_config) | Configuration for Starboard |
| <a name="output_velero_config"></a> [velero\_config](#output\_velero\_config) | Configuration for Velero |
