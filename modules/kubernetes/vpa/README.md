# Vertical Pod Autoscaler/

Adds [`VPA`](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) using
[`FairwindsOps`](https://github.com/FairwindsOps/charts/tree/master/stable/vpa) helm chart to deploy VPA.
VPA recommender is the only feature enabled, it's not possible to auto update deployments from VPA.
[`Goldilocks`](https://github.com/FairwindsOps/charts/tree/master/stable/goldilocks) is used to auto create
VPA config to all kinds of workloads. This will help us generate metrics for our tenants and the platform.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_git"></a> [git](#provider\_git) | 0.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [git_repository_file.goldilocks](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |
| [git_repository_file.vpa](https://registry.terraform.io/providers/xenitab/git/0.0.3/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |

## Outputs

No outputs.
