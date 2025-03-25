/**
  * # External DNS (external-dns)
  *
  * This module is used to add [`external-dns`](https://github.com/kubernetes-sigs/external-dns) to Kubernetes clusters.
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
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "external_dns_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/external-dns/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "external_dns_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/external-dns/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "external_dns_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/external-dns-app.yaml"
  content = templatefile("${path.module}/templates/external-dns-app.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "external_dns" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/external-dns/templates/external-dns.yaml"
  content = templatefile("${path.module}/templates/external-dns.yaml.tpl", {
    client_id           = azurerm_user_assigned_identity.external_dns.client_id
    provider            = var.dns_provider
    resource_group_name = var.global_resource_group_name
    sources             = var.sources
    extra_args          = var.extra_args
    subscription_id     = var.subscription_id
    tenant_id           = azurerm_user_assigned_identity.external_dns.tenant_id
    txt_owner_id        = var.txt_owner_id
    project             = var.fleet_infra_config.argocd_project_name
    server              = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "external_dns_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/external-dns/templates/external-dns-extras.yaml"
  content = templatefile("${path.module}/templates/external-dns-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "external_dns_manifests" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/external-dns/manifests/external-dns-extras.yaml"
  content = templatefile("${path.module}/templates/external-dns-manifests.yaml.tpl", {
    aad_groups = var.aad_groups
    namespaces = var.namespaces
  })
}
