/**
  * # Ingress NGINX (ingress-nginx)
  *
  * This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "ingress_nginx_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/ingress-nginx/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "ingress_nginx_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/ingress-nginx/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "ingress_nginx_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/ingress-nginx-app.yaml"
  content = templatefile("${path.module}/templates/ingress-nginx-app.yaml.tpl", {
    tenant_name        = var.tenant_name
    environment        = var.environment
    cluster_id         = var.cluster_id
    project            = var.fleet_infra_config.argocd_project_name
    repo_url           = var.fleet_infra_config.git_repo_url
    ingress_nginx_name = "ingress-nginx"
  })
}

resource "git_repository_file" "ingress_nginx" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/ingress-nginx/templates/ingress-nginx.yaml"
  content = templatefile("${path.module}/templates/ingress-nginx.yaml.tpl", {
    tenant_name            = var.tenant_name
    environment            = var.environment
    project                = var.fleet_infra_config.argocd_project_name
    server                 = var.fleet_infra_config.k8s_api_server_url
    ingress_class          = "nginx"
    ingress_nginx_name     = "ingress-nginx"
    default_ingress_class  = true
    internal_load_balancer = false
    replicas               = var.replicas
    min_replicas           = var.min_replicas
    external_dns_hostname  = var.external_dns_hostname
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    private_ingress_enabled             = var.private_ingress_enabled
    allow_snippet_annotations           = var.customization.allow_snippet_annotations
    http_snippet                        = var.customization.http_snippet
    extra_config                        = var.customization.extra_config
    extra_headers                       = var.customization.extra_headers
    linkerd_enabled                     = var.linkerd_enabled
    datadog_enabled                     = var.datadog_enabled
    nginx_healthz_ingress_enabled       = true
    nginx_healthz_ingress_whitelist_ips = var.nginx_healthz_ingress_whitelist_ips
    nginx_healthz_ingress_hostname      = var.nginx_healthz_ingress_hostname
  })
}

resource "git_repository_file" "ingress_nginx_private" {
  for_each = {
    for s in ["ingress-nginx-private"] :
    s => s
    if var.private_ingress_enabled
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/ingress-nginx/templates/ingress-nginx-private.yaml"
  content = templatefile("${path.module}/templates/ingress-nginx.yaml.tpl", {
    tenant_name            = var.tenant_name
    environment            = var.environment
    project                = var.fleet_infra_config.argocd_project_name
    server                 = var.fleet_infra_config.k8s_api_server_url
    ingress_class          = "nginx-private"
    ingress_nginx_name     = "ingress-nginx-private"
    default_ingress_class  = false
    internal_load_balancer = true
    replicas               = var.replicas
    min_replicas           = var.min_replicas
    external_dns_hostname  = var.external_dns_hostname
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    private_ingress_enabled             = var.private_ingress_enabled
    allow_snippet_annotations           = var.customization_private.allow_snippet_annotations == null ? var.customization.allow_snippet_annotations : var.customization_private.allow_snippet_annotations
    http_snippet                        = var.customization_private.http_snippet == null ? var.customization.http_snippet : var.customization_private.http_snippet
    extra_config                        = merge(var.customization.extra_config, var.customization_private.extra_config)
    extra_headers                       = merge(var.customization.extra_headers, var.customization_private.extra_config)
    linkerd_enabled                     = var.linkerd_enabled
    datadog_enabled                     = var.datadog_enabled
    nginx_healthz_ingress_enabled       = false
    nginx_healthz_ingress_whitelist_ips = var.nginx_healthz_ingress_whitelist_ips
    nginx_healthz_ingress_hostname      = var.nginx_healthz_ingress_hostname
  })
}

resource "git_repository_file" "ingress_nginx_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/ingress-nginx/templates/ingress-nginx-extras.yaml"
  content = templatefile("${path.module}/templates/ingress-nginx-extras.yaml.tpl", {
    tenant_name        = var.tenant_name
    environment        = var.environment
    cluster_id         = var.cluster_id
    project            = var.fleet_infra_config.argocd_project_name
    repo_url           = var.fleet_infra_config.git_repo_url
    server             = var.fleet_infra_config.k8s_api_server_url
    ingress_nginx_name = "ingress-nginx"
  })
}

resource "git_repository_file" "ingress_nginx_manifests" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/ingress-nginx/manifests/ingress-nginx-extras.yaml"
  content = templatefile("${path.module}/templates/ingress-nginx-manifests.yaml.tpl", {
    aad_groups         = var.aad_groups
    namespaces         = var.namespaces
    ingress_nginx_name = "ingress-nginx"
    default_certificate = {
      enabled         = var.default_certificate.enabled
      dns_zone        = var.default_certificate.dns_zone
      namespaced_name = "ingress-nginx/ingress-nginx"
    }
    nginx_healthz_ingress_enabled       = true
    nginx_healthz_ingress_whitelist_ips = var.nginx_healthz_ingress_whitelist_ips
    nginx_healthz_ingress_hostname      = var.nginx_healthz_ingress_hostname
  })
}
