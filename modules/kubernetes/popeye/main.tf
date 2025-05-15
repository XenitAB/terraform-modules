/**
  * # Popeye (popeye)
  *
  * This module is used to add Popeye [`popeye`](https://github.com/derailed/popeye) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

data "azurerm_storage_account" "log" {
  name                = var.popeye_config.storage_account.account_name
  resource_group_name = var.popeye_config.storage_account.resource_group_name
}

resource "git_repository_file" "popeye" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/popeye.yaml"
  content = templatefile("${path.module}/templates/popeye.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "cluster_role_binding" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/templates/cluster-role-binding.yaml"
  content = templatefile("${path.module}/charts/popeye/templates/cluster-role-binding.yaml", {
  })
}

resource "git_repository_file" "cluster_role" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/templates/cluster-role.yaml"
  content = templatefile("${path.module}/charts/popeye/templates/cluster-role.yaml", {
  })
}

resource "git_repository_file" "config_map" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/templates/config-map.yaml"
  content = templatefile("${path.module}/charts/popeye/templates/config-map.yaml", {
  })
}

resource "git_repository_file" "cronjob" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/templates/cronjob.yaml"
  content = templatefile("${path.module}/charts/popeye/templates/cronjob.yaml", {
  })
}

resource "git_repository_file" "pvc" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/templates/pvc.yaml"
  content = templatefile("${path.module}/charts/popeye/templates/pvc.yaml", {
  })
}

resource "git_repository_file" "secret" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/templates/secret.yaml"
  content = templatefile("${path.module}/charts/popeye/templates/secret.yaml", {
  })
}

resource "git_repository_file" "service_account" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/templates/service-account.yaml"
  content = templatefile("${path.module}/charts/popeye/templates/service-account.yaml", {
  })
}

resource "git_repository_file" "storage_class" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/templates/storage-class.yaml"
  content = templatefile("${path.module}/charts/popeye/templates/storage-class.yaml", {
  })
}

resource "git_repository_file" "helmignore" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/.helmignore"
  content = templatefile("${path.module}/charts/popeye/.helmignore", {
  })
}

resource "git_repository_file" "chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/Chart.yaml"
  content = templatefile("${path.module}/charts/popeye/Chart.yaml", {
  })
}

resource "git_repository_file" "values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/popeye/charts/popeye/values.yaml"
  content = templatefile("${path.module}/charts/popeye/values.yaml.tpl", {
    allowed_registries   = var.popeye_config.allowed_registries
    client_id            = azurerm_user_assigned_identity.popeye.client_id
    cron_jobs            = var.popeye_config.cron_jobs
    location             = var.location
    resource_group_name  = var.popeye_config.storage_account.resource_group_name
    storage_account_name = data.azurerm_storage_account.log.name
    storage_account_key  = data.azurerm_storage_account.log.primary_access_key
    file_share_size      = var.popeye_config.storage_account.file_share_size
  })
}