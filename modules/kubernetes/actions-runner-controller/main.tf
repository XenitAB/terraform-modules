/**
  * # GitHub Actions Runner Controller (ARC)
  *
  * This module is used to add the [`gha-runner-scale-set-controller`](https://github.com/actions/actions-runner-controller)
  * to Kubernetes clusters.
  *
  * The controller is always deployed. The runner scale set and its GitHub App
  * credentials (ExternalSecret) are only generated when `arc_runner_set_config`
  * is set, since they're tenant-specific (target org/repo, GitHub App).
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
    min_runners           = var.arc_runner_set_config.min_runners
    max_runners           = var.arc_runner_set_config.max_runners
  })
}

resource "git_repository_file" "arc_external_secret" {
  count = var.arc_runner_set_config != null ? 1 : 0

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/templates/external-secret-arc.yaml"
  content = templatefile("${path.module}/templates/external-secret-arc.yaml.tpl", {
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
