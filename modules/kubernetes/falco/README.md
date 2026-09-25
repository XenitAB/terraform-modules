# Falco

Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.

Rule metrics are exposed by Falco's own Prometheus endpoint
(`webserver.prometheus_metrics_enabled`). The separate `falco-exporter`
component this module used to deploy was archived upstream in July 2025 and
has been removed.

The stable ruleset baked into the Falco image covers only a fraction of the
rules our exception macros are written for; the incubating and sandbox
rulesets are pulled in as OCI artifacts by falcoctl and listed explicitly in
`falco.rules_files`. See the comments in `templates/falco.yaml.tpl`.

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [git_repository_file.falco](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.falco_app](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.falco_chart](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.falco_values](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cilium_enabled"></a> [cilium\_enabled](#input\_cilium\_enabled) | If enabled, will use Azure CNI with Cilium instead of kubenet | `bool` | `false` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_driver_kind"></a> [driver\_kind](#input\_driver\_kind) | Which Falco driver to use. Falco 0.44 removed the legacy BPF probe, so the remaining options are modern\_ebpf, kmod and auto. | `string` | `"modern_ebpf"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.
