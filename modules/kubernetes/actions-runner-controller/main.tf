/**
  * # GitHub Actions Runner Controller (ARC)
  *
  * This module is used to add the [`gha-runner-scale-set-controller`](https://github.com/actions/actions-runner-controller)
  * to Kubernetes clusters.
  *
  * The controller is always deployed. The runner scale set and its GitHub App
  * credentials (ExternalSecret) are only generated when `arc_runner_set_config`
  * is set, since they're tenant-specific (target org/repo, GitHub App).
  *
  * ## Credentials ownership and migration
  *
  * Credentials use a raw-manifest child Application named `arc-credentials` in
  * `<tenant>-<environment>`. It targets `fleet_infra_config.k8s_api_server_url`,
  * the same server as the runners, and owns the `arc-runners` Namespace,
  * ExternalSecret, SecretStore, and ESO ServiceAccount. The runner Application
  * no longer creates or manages the Namespace. Ensure the ArgoCD project permits
  * this destination and these resources, including the cluster-scoped Namespace.
  *
  * Set `arc_runner_set_config.credentials_migration_phase` to `protect`,
  * `handoff`, or `managed` (default). New installations use `managed` directly.
  * Existing installations MUST complete `protect` then `handoff` before
  * `managed`; never upgrade an existing installation directly to the default.
  * Every typed root/wrapper object forwarding `arc_runner_set_config` must expose
  * `credentials_migration_phase = optional(string, "managed")`, otherwise
  * Terraform silently drops the field and the module uses `managed`.
  *
  * 1. Set `protect` before generating updated fleet files. Sync the parent at
  *    this revision and verify `argocd.argoproj.io/sync-options: Prune=false`
  *    LIVE on all four old-cluster resources: Namespace, ExternalSecret,
  *    SecretStore, and ESO ServiceAccount (on the management cluster for legacy
  *    remote installs). The original `templates/external-secret-arc.yaml` stays
  *    in the parent Helm chart with Helm-escaped ESO expressions; no credentials
  *    child is generated. If a wave blocks progress, quiesce outstanding parent
  *    syncs: temporarily disable automatic sync at the authoritative owning
  *    configuration, ensure the root cannot restore it during maintenance, and
  *    terminate sync operations, NEVER delete Applications. Selectively sync
  *    the four resources at the intended revision if necessary. Verify all four
  *    live annotations even if the parent is not Healthy; never skip this gate.
  * 2. Set `handoff` and generate the next fleet revision. The existing Terraform
  *    resource address `git_repository_file.arc_external_secret[0]` is retained,
  *    but its path moves to `manifests/credentials/external-secret-arc.yaml`.
  *    The new child uses explicit `source.directory` raw manifests, plain ESO
  *    expressions, and NO automated sync. All four resources retain `Prune=false`.
  *    Ensure the parent is at the intended revision, the child Application exists,
  *    and old credentials resources are absent from the parent's desired output
  *    but retained live with `Prune=false`. Ensure no old-revision parent sync is
  *    still running; use the quiescing procedure above if wave-blocked. Skipped
  *    pruning can leave the parent OutOfSync. Manually sync `arc-credentials`
  *    WITHOUT requiring parent Healthy status or full sync success, using regular
  *    apply, WITHOUT force, replace, or destructive recreation. On the same
  *    cluster, verify ArgoCD tracking adoption by the child. Verify all four child
  *    resources still have `Prune=false`, SecretStore and ExternalSecret report
  *    Ready, and the `arc-github-app` Secret exists, without exposing its contents.
  * 3. Only after adoption/readiness checks, set `managed` and reconcile. This
  *    enables child automated prune/selfHeal and removes the four protection
  *    annotations. Verify the child now owns the resources and runners are healthy.
  *    Restore any temporarily disabled parent/root automatic sync in the owning
  *    configuration only after confirming it retains the intended managed revision.
  *
  * Credentials wave 0 and runners wave 1 control sync-wave admission. This repo's
  * Application health customization propagates child health, so a pending child
  * can stall a parent wave, including remote protect/handoff. Waiting for parent
  * completion before manually syncing the handoff child can deadlock. Application
  * health and wave admission are not proof of ESO readiness; verify it explicitly.
  *
  * After child sync/adoption, migration is FORWARD-ONLY. Returning from `handoff`
  * or `managed` to `protect`, reverting to the old module, disabling ARC/removing
  * its configuration, removing the ARC wrapper from the root, or cascading root
  * deletion can remove the finalized child and delete its Namespace/credentials,
  * EVEN with `Prune=false`. This annotation prevents pruning, not finalizer-driven
  * deletion. Rollback requires a separate, reviewed NONCASCADING ownership plan;
  * never blindly revert or clean up. Do not delete parent/child Applications or
  * manually delete/recreate the credentials Namespace during migration.
  *
  * For existing remote-cluster installs, credentials previously landed on the
  * management cluster. They CANNOT be adopted across clusters: the child creates
  * new resources on the runner server while the old management-cluster resources
  * remain protected. Verify remote ESO readiness and runner operation first, then
  * use a separately reviewed ownership/cleanup plan for obsolete management-cluster
  * resources, checking tracking, finalizers, and shared workloads before removal.
  * Never automatically delete the old Namespace; it may contain other workloads.
  *
  * These phases change generated Git files and Kubernetes ownership/sync lifecycle,
  * not Azure identity, federation, or vault policy. Review each Terraform plan for
  * the intended Git changes only; do not apply Azure resource changes as part of
  * this migration. Publishing each phase and ArgoCD reconciliation are separate
  * operator-controlled checkpoints.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.57.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "arc_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "arc_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "arc_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/actions-runner-controller-app.yaml"
  content = templatefile("${path.module}/templates/actions-runner-controller-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "arc_controller" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/templates/actions-runner-controller.yaml"
  content = templatefile("${path.module}/templates/actions-runner-controller.yaml.tpl", {
    tenant_name          = var.tenant_name
    environment          = var.environment
    project              = var.fleet_infra_config.argocd_project_name
    server               = var.fleet_infra_config.k8s_api_server_url
    arc_config           = var.arc_config
    service_account_name = local.service_account_name
  })
}

resource "git_repository_file" "arc_runner_set" {
  count = var.arc_runner_set_config != null ? 1 : 0

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/templates/arc-runner-set.yaml"
  content = templatefile("${path.module}/templates/arc-runner-set.yaml.tpl", {
    tenant_name           = var.tenant_name
    environment           = var.environment
    project               = var.fleet_infra_config.argocd_project_name
    server                = var.fleet_infra_config.k8s_api_server_url
    chart_version         = var.arc_config.chart_version
    runners_namespace     = local.runners_namespace
    controller_namespace  = var.arc_config.namespace
    service_account_name  = local.service_account_name
    runner_scale_set_name = var.arc_runner_set_config.runner_scale_set_name
    github_config_url     = var.arc_runner_set_config.github_config_url
    runner_group          = var.arc_runner_set_config.runner_group
    min_runners           = var.arc_runner_set_config.min_runners
    max_runners           = var.arc_runner_set_config.max_runners
  })
}

resource "git_repository_file" "arc_external_secret" {
  count = var.arc_runner_set_config != null ? 1 : 0

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/${var.arc_runner_set_config.credentials_migration_phase == "protect" ? "templates" : "manifests/credentials"}/external-secret-arc.yaml"
  content = templatefile("${path.module}/templates/external-secret-arc.yaml.tpl", {
    legacy_helm_template       = var.arc_runner_set_config.credentials_migration_phase == "protect"
    prune_protection           = var.arc_runner_set_config.credentials_migration_phase != "managed"
    runners_namespace          = local.runners_namespace
    eso_service_account_name   = local.eso_service_account_name
    eso_client_id              = azurerm_user_assigned_identity.arc[0].client_id
    azure_tenant_id            = var.azure_tenant_id
    github_app_id              = var.arc_runner_set_config.github_app_id
    github_app_installation_id = var.arc_runner_set_config.github_app_installation_id
    key_vault_name             = var.arc_runner_set_config.key_vault_name
    key_vault_secret_name      = var.arc_runner_set_config.key_vault_secret_name
  })
}

resource "git_repository_file" "arc_credentials" {
  count = var.arc_runner_set_config == null ? 0 : (var.arc_runner_set_config.credentials_migration_phase == "protect" ? 0 : 1)

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/templates/arc-credentials.yaml"
  content = templatefile("${path.module}/templates/arc-credentials.yaml.tpl", {
    tenant_name       = var.tenant_name
    environment       = var.environment
    cluster_id        = var.cluster_id
    project           = var.fleet_infra_config.argocd_project_name
    repo_url          = var.fleet_infra_config.git_repo_url
    server            = var.fleet_infra_config.k8s_api_server_url
    runners_namespace = local.runners_namespace
    automated         = var.arc_runner_set_config.credentials_migration_phase == "managed"
  })
}
