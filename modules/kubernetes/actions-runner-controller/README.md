# GitHub Actions Runner Controller (ARC)

This module is used to add the [`gha-runner-scale-set-controller`](https://github.com/actions/actions-runner-controller)
to Kubernetes clusters.

The controller is always deployed. The runner scale set and its GitHub App
credentials (ExternalSecret) are only generated when `arc_runner_set_config`
is set, since they're tenant-specific (target org/repo, GitHub App).

## Credentials ownership and migration

Credentials use a raw-manifest child Application named `arc-credentials` in
`<tenant>-<environment>`. It targets `fleet_infra_config.k8s_api_server_url`,
the same server as the runners, and owns the `arc-runners` Namespace,
ExternalSecret, SecretStore, and ESO ServiceAccount. The runner Application
no longer creates or manages the Namespace. Ensure the ArgoCD project permits
this destination and these resources, including the cluster-scoped Namespace.

Set `arc_runner_set_config.credentials_migration_phase` to `protect`,
`handoff`, or `managed` (default). New installations use `managed` directly.
Existing installations MUST complete `protect` then `handoff` before
`managed`; never upgrade an existing installation directly to the default.
Every typed root/wrapper object forwarding `arc_runner_set_config` must expose
`credentials_migration_phase = optional(string, "managed")`, otherwise
Terraform silently drops the field and the module uses `managed`.

1. Set `protect` before generating updated fleet files. Sync the parent at
   this revision and verify `argocd.argoproj.io/sync-options: Prune=false`
   LIVE on all four old-cluster resources: Namespace, ExternalSecret,
   SecretStore, and ESO ServiceAccount (on the management cluster for legacy
   remote installs). The original `templates/external-secret-arc.yaml` stays
   in the parent Helm chart with Helm-escaped ESO expressions; no credentials
   child is generated. If a wave blocks progress, quiesce outstanding parent
   syncs: temporarily disable automatic sync at the authoritative owning
   configuration, ensure the root cannot restore it during maintenance, and
   terminate sync operations, NEVER delete Applications. Selectively sync
   the four resources at the intended revision if necessary. Verify all four
   live annotations even if the parent is not Healthy; never skip this gate.
2. Set `handoff` and generate the next fleet revision. The existing Terraform
   resource address `git_repository_file.arc_external_secret[0]` is retained,
   but its path moves to `manifests/credentials/external-secret-arc.yaml`.
   The new child uses explicit `source.directory` raw manifests, plain ESO
   expressions, and NO automated sync. All four resources retain `Prune=false`.
   Ensure the parent is at the intended revision, the child Application exists,
   and old credentials resources are absent from the parent's desired output
   but retained live with `Prune=false`. Ensure no old-revision parent sync is
   still running; use the quiescing procedure above if wave-blocked. Skipped
   pruning can leave the parent OutOfSync. Manually sync `arc-credentials`
   WITHOUT requiring parent Healthy status or full sync success, using regular
   apply, WITHOUT force, replace, or destructive recreation. On the same
   cluster, verify ArgoCD tracking adoption by the child. Verify all four child
   resources still have `Prune=false`, SecretStore and ExternalSecret report
   Ready, and the `arc-github-app` Secret exists, without exposing its contents.
3. Only after adoption/readiness checks, set `managed` and reconcile. This
   enables child automated prune/selfHeal and removes the four protection
   annotations. Verify the child now owns the resources and runners are healthy.
   Restore any temporarily disabled parent/root automatic sync in the owning
   configuration only after confirming it retains the intended managed revision.

Credentials wave 0 and runners wave 1 control sync-wave admission. This repo's
Application health customization propagates child health, so a pending child
can stall a parent wave, including remote protect/handoff. Waiting for parent
completion before manually syncing the handoff child can deadlock. Application
health and wave admission are not proof of ESO readiness; verify it explicitly.

After child sync/adoption, migration is FORWARD-ONLY. Returning from `handoff`
or `managed` to `protect`, reverting to the old module, disabling ARC/removing
its configuration, removing the ARC wrapper from the root, or cascading root
deletion can remove the finalized child and delete its Namespace/credentials,
EVEN with `Prune=false`. This annotation prevents pruning, not finalizer-driven
deletion. Rollback requires a separate, reviewed NONCASCADING ownership plan;
never blindly revert or clean up. Do not delete parent/child Applications or
manually delete/recreate the credentials Namespace during migration.

For existing remote-cluster installs, credentials previously landed on the
management cluster. They CANNOT be adopted across clusters: the child creates
new resources on the runner server while the old management-cluster resources
remain protected. Verify remote ESO readiness and runner operation first, then
use a separately reviewed ownership/cleanup plan for obsolete management-cluster
resources, checking tracking, finalizers, and shared workloads before removal.
Never automatically delete the old Namespace; it may contain other workloads.

These phases change generated Git files and Kubernetes ownership/sync lifecycle,
not Azure identity, federation, or vault policy. Review each Terraform plan for
the intended Git changes only; do not apply Azure resource changes as part of
this migration. Publishing each phase and ArgoCD reconciliation are separate
operator-controlled checkpoints.

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.57.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.57.0 |
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_federated_identity_credential.arc_external_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault_access_policy.arc](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_user_assigned_identity.arc](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/user_assigned_identity) | resource |
| [git_repository_file.arc_app](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_chart](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_controller](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_credentials](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_external_secret](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_runner_set](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.arc_values](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | The AKS cluster short name, e.g. 'aks'. Required if arc\_runner\_set\_config is set. | `string` | `""` | no |
| <a name="input_arc_config"></a> [arc\_config](#input\_arc\_config) | Configuration for the GitHub Actions Runner Controller (ARC) controller deployment. | <pre>object({<br/>    chart_version             = optional(string, "0.14.2")<br/>    namespace                 = optional(string, "arc-system")<br/>    replica_count             = optional(number, 1)<br/>    watch_single_namespace    = optional(string, "")<br/>    resources_cpu_requests    = optional(string, "50m")<br/>    resources_memory_requests = optional(string, "128Mi")<br/>    resources_memory_limit    = optional(string, "512Mi")<br/>  })</pre> | `{}` | no |
| <a name="input_arc_runner_set_config"></a> [arc\_runner\_set\_config](#input\_arc\_runner\_set\_config) | Configuration for the runner scale set and its GitHub App credentials. Leave null to deploy only the controller. | <pre>object({<br/>    runner_scale_set_name       = string<br/>    github_config_url           = string<br/>    github_app_id               = string<br/>    github_app_installation_id  = string<br/>    key_vault_name              = string<br/>    key_vault_secret_name       = optional(string, "github-arc-private-key")<br/>    runner_group                = optional(string, "")<br/>    min_runners                 = optional(number, 0)<br/>    max_runners                 = optional(number, 8)<br/>    credentials_migration_phase = optional(string, "managed")<br/>  })</pre> | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure AD tenant ID for the ExternalSecret's SecretStore. Required if arc\_runner\_set\_config is set. | `string` | `""` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Resource ID of the Key Vault holding the GitHub App private key. Required if arc\_runner\_set\_config is set. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region name. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The short name of the Azure region, e.g. 'sdc'. Required if arc\_runner\_set\_config is set. | `string` | `""` | no |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_eso_client_id"></a> [eso\_client\_id](#output\_eso\_client\_id) | Client ID of the dedicated identity federated for the runner scale set's ExternalSecret. Null if arc\_runner\_set\_config was not set. |
