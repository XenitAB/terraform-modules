/**
  * # Kyverno (kyverno)
  *
  * This module is used to add [`kyverno`](https://github.com/kubernetes-sigs/kyverno) to Kubernetes clusters.
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

resource "git_repository_file" "kyverno_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kyverno/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "kyverno_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kyverno/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "kyverno_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/kyverno-app.yaml"
  content = templatefile("${path.module}/templates/kyverno-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "kyverno" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kyverno/templates/kyverno.yaml"
  content = templatefile("${path.module}/templates/kyverno.yaml.tpl", {
    client_id           = azurerm_user_assigned_identity.kyverno.client_id
    resource_group_name = var.global_resource_group_name
    subscription_id     = var.subscription_id
    tenant_id           = azurerm_user_assigned_identity.kyverno.tenant_id
    tenant_name         = var.tenant_name
    environment         = var.environment
    project             = var.fleet_infra_config.argocd_project_name
    server              = var.fleet_infra_config.k8s_api_server_url
    config              = var.kyverno_config
  })
}

resource "git_repository_file" "kyverno_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kyverno/templates/kyverno-extras.yaml"
  content = templatefile("${path.module}/templates/kyverno-extras.yaml.tpl", {
    tenant_name         = var.tenant_name
    environment         = var.environment
    cluster_id          = var.cluster_id
    project             = var.fleet_infra_config.argocd_project_name
    repo_url            = var.fleet_infra_config.git_repo_url
    server              = var.fleet_infra_config.k8s_api_server_url
    client_id           = azurerm_user_assigned_identity.kyverno.client_id
    tenant_id           = azurerm_user_assigned_identity.kyverno.tenant_id
    resource_group_name = var.global_resource_group_name

  })
}

resource "git_repository_file" "kyverno_audit_policies" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kyverno/manifests/policies/kyverno-audit-policies.yaml"
  content = templatefile("${path.module}/templates/kyverno-audit-policies.yaml.tpl", {
  })
}

resource "git_repository_file" "kyverno_mutation_policies" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kyverno/manifests/policies/kyverno-mutation-policies.yaml"
  content = templatefile("${path.module}/templates/kyverno-mutation-policies.yaml.tpl", {
  })
}

resource "git_repository_file" "kyverno_security_policies" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kyverno/manifests/policies/kyverno-security-policies.yaml"
  content = templatefile("${path.module}/templates/kyverno-security-policies.yaml.tpl", {

  })
}

resource "git_repository_file" "kyverno_flux_policies" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/kyverno/manifests/policies/kyverno-flux-policies.yaml"
  content = templatefile("${path.module}/templates/kyverno-flux-policies.yaml.tpl", {

  })
}