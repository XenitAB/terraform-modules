/**
  * # GitHub Actions Runner Controller (ARC)
  *
  * This module is used to add the [`gha-runner-scale-set-controller`](https://github.com/actions/actions-runner-controller)
  * to Kubernetes clusters.
  *
  * The module only deploys the controller itself. It is disabled by default (`enabled = false`) and
  * requires no other input to be added to a cluster's module list ahead of time - flip `enabled` to `true`
  * when a tenant actually needs self-hosted runners. Runner scale sets (`AutoscalingRunnerSet`) are highly
  * tenant-specific (GitHub App credentials, target org/repo, node placement) and are intentionally out of
  * scope for this module; deploy them as additional Argo CD Applications alongside it, reusing the
  * `workload_identity` output if they need Azure access.
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
  count = var.enabled ? 1 : 0

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "arc_values" {
  count = var.enabled ? 1 : 0

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "arc_app" {
  count = var.enabled ? 1 : 0

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
  count = var.enabled ? 1 : 0

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/actions-runner-controller/templates/actions-runner-controller.yaml"
  content = templatefile("${path.module}/templates/actions-runner-controller.yaml.tpl", {
    tenant_name          = var.tenant_name
    environment          = var.environment
    project              = var.fleet_infra_config.argocd_project_name
    server               = var.fleet_infra_config.k8s_api_server_url
    client_id            = azurerm_user_assigned_identity.arc[0].client_id
    arc_config           = var.arc_config
    service_account_name = local.service_account_name
  })
}
