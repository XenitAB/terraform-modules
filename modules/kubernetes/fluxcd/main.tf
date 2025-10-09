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

# ------------------------------------------------------------
# Argo CD application pattern (no direct in-cluster bootstrap)
# ------------------------------------------------------------

# 1. Flux app-of-apps Application (references chart directory with an Application for flux controllers)
resource "git_repository_file" "flux_app_of_apps" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/flux-app.yaml"
  content = templatefile("${path.module}/templates/flux-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

# 2. Chart.yaml for our lightweight meta chart that embeds an Argo Application for flux
resource "git_repository_file" "flux_chart" {
  path    = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/flux/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {})
}

# 3. values.yaml (currently minimal, placeholder for future overrides)
resource "git_repository_file" "flux_values" {
  path    = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/flux/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {})
}

# 4. Flux controllers Application manifest (inside the chart)
resource "git_repository_file" "flux_application" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/flux/templates/flux.yaml"
  content = templatefile("${path.module}/templates/flux.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    client_id   = azurerm_user_assigned_identity.flux_system.client_id
  })
}

resource "git_repository_file" "tenant_app" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.fluxcd != null
  }

  override_on_create = true
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/flux/templates/${each.key}-app.yaml"
  content            = templatefile("${path.module}/templates/tenant-app.yaml.tpl", {
    name             = each.key,
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    environment = var.environment
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url

  })
}

resource "git_repository_file" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.fluxcd != null
  }

  override_on_create = true
  path               = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/flux/tenants/${each.key}/${each.key}.yaml"
  content            = templatefile("${path.module}/templates/tenant.yaml.tpl", {
    environment      = var.environment,
    name             = each.key,
    provider_type    = var.git_provider.type,
    provider         = (var.git_provider.type == "azuredevops" ? "azure" : "github"),
    url              = (var.git_provider.type == "azuredevops" ?
      "https://dev.azure.com/${var.git_provider.organization}/${each.value.fluxcd.project}/_git/${each.value.fluxcd.repository}" :
      "https://github.com/${var.git_provider.organization}/${each.value.fluxcd.repository}.git"
    ),
    tenant_path      = (each.value.fluxcd.include_tenant_name ? "./tenant/${var.environment}/${each.key}" : "./tenant/${var.environment}"),
    create_crds      = each.value.fluxcd.create_crds,
    github_app_id    = base64encode(var.git_provider.github.application_id),
    github_installation_id = base64encode(var.git_provider.github.installation_id),
    github_app_key   = base64encode(var.git_provider.github.private_key),

  })
}