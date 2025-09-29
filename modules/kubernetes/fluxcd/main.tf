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
  depends_on = [git_repository_file.flux_root]
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
  depends_on = [git_repository_file.flux_root]
  path    = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/flux/Chart.yaml"
  content = templatefile("${path.module}/templates/flux-Chart.yaml.tpl", {})
}

# 3. values.yaml (currently minimal, placeholder for future overrides)
resource "git_repository_file" "flux_values" {
  depends_on = [git_repository_file.flux_root]
  path    = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/flux/values.yaml"
  content = templatefile("${path.module}/templates/flux-values.yaml.tpl", {})
}

# 4. Flux controllers Application manifest (inside the chart)
resource "git_repository_file" "flux_application" {
  depends_on = [git_repository_file.flux_chart, git_repository_file.flux_values]
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/flux/templates/flux.yaml"
  content = templatefile("${path.module}/templates/flux.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    client_id   = azurerm_user_assigned_identity.flux_system.client_id
  })
}

# 5. Tenants definitions (GitRepositories + Kustomizations)
resource "git_repository_file" "tenant" {
  depends_on = [git_repository_file.flux_root]
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.fluxcd != null
  }

  override_on_create = true
  path               = "tenants/${var.cluster_id}/${each.key}.yaml"
  content            = templatefile("${path.module}/templates/tenant.yaml", {
    environment      = var.environment,
    name             = each.key,
    provider_type    = var.git_provider.type,
    url              = (var.git_provider.type == "azuredevops" ?
      "https://dev.azure.com/${var.git_provider.organization}/${each.value.fluxcd.project}/_git/${each.value.fluxcd.repository}" :
      "https://github.com/${var.git_provider.organization}/${each.value.fluxcd.repository}.git"
    ),
    tenant_path      = (each.value.fluxcd.include_tenant_name ?
      "./tenant/${var.environment}/${each.key}" :
      "./tenant/${var.environment}"),
    crd_block        = (each.value.fluxcd.create_crds ? template(<<EOT
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: flux-tenant-${each.key}-crd-manage
rules:
- apiGroups: ["apiextensions.k8s.io"]
  resources: ["customresourcedefinitions"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: flux-tenant-${each.key}-crd-manage
subjects:
  - apiGroup: ""
    kind: ServiceAccount
    name: flux
    namespace: ${each.key}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: flux-tenant-${each.key}-crd-manage
EOT
    , {}) : "")
  })
}
