/**
  * # Falco
  *
  * Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
  *
  * Rule metrics are exposed by Falco's own Prometheus endpoint
  * (`webserver.prometheus_metrics_enabled`). The separate `falco-exporter`
  * component this module used to deploy was archived upstream in July 2025 and
  * has been removed.
  *
  * The stable ruleset baked into the Falco image covers only a fraction of the
  * rules our exception macros are written for; the incubating and sandbox
  * rulesets are pulled in as OCI artifacts by falcoctl and listed explicitly in
  * `falco.rules_files`. See the comments in `templates/falco.yaml.tpl`.
  */

terraform {
  required_version = ">= 1.11.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = ">=0.0.4"
    }
  }
}

resource "git_repository_file" "falco_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "falco_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "falco_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/falco-app.yaml"
  content = templatefile("${path.module}/templates/falco-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "falco" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/falco/templates/falco.yaml"
  content = templatefile("${path.module}/templates/falco.yaml.tpl", {
    cilium_enabled = var.cilium_enabled
    driver_kind    = var.driver_kind
    tenant_name    = var.tenant_name
    environment    = var.environment
    project        = var.fleet_infra_config.argocd_project_name
    server         = var.fleet_infra_config.k8s_api_server_url
  })
}
