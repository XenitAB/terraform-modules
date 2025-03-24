/**
  * # Trivy
  *
  * Adds [`Trivy-operator`](https://github.com/aquasecurity/trivy-operator) and
  * [`Trivy`](https://github.com/aquasecurity/trivy) to a Kubernetes clusters.
  * The modules consists of two components, trivy and trivy-operator where
  * Trivy is used as a server to store aqua security image vulnerability database.
  * Trivy-operator is used to trigger image and config scans on newly created replicasets and
  * generates a CR with a report that both admins and developers can use to improve there setup.
  *
  * [`starboard-exporter`](https://github.com/giantswarm/starboard-exporter) is used to gather
  * trivy metrics from trivy-operator CRD:s.
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

resource "git_repository_file" "trivy_chart" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/trivy/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {
  })
}

resource "git_repository_file" "trivy_values" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/trivy/values.yaml"
  content = templatefile("${path.module}/templates/values.yaml", {
  })
}

# App-of-apps
resource "git_repository_file" "trivy_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/trivy-app.yaml"
  content = templatefile("${path.module}/templates/trivy-app.yaml.tpl", {
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "trivy_operator" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/trivy/templates/trivy-operator.yaml"
  content = templatefile("${path.module}/templates/trivy-operator.yaml.tpl", {
    client_id = azurerm_user_assigned_identity.trivy.client_id
    project   = var.fleet_infra_config.argocd_project_name
    server    = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "trivy" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/trivy/templates/trivy.yaml"
  content = templatefile("${path.module}/templates/trivy.yaml.tpl", {
    client_id                       = azurerm_user_assigned_identity.trivy.client_id,
    volume_claim_storage_class_name = var.volume_claim_storage_class_name
    project                         = var.fleet_infra_config.argocd_project_name
    server                          = var.fleet_infra_config.k8s_api_server_url
  })
}

resource "git_repository_file" "starboard_exporter" {
  for_each = {
    for s in ["starboard_exporter"] :
    s => s
    if var.starboard_exporter_enabled
  }

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/trivy/templates/starboard-eporter.yaml"
  content = templatefile("${path.module}/templates/starboard-exporter.yaml.tpl", {
    project = var.fleet_infra_config.argocd_project_name
    server  = var.fleet_infra_config.k8s_api_server_url
  })
}
