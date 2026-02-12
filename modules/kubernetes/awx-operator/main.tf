/**
  * # AWX Operator
  *
  * This module deploys the [AWX Operator](https://github.com/ansible/awx-operator) to Kubernetes clusters.
  * AWX provides a web-based user interface, REST API, and task engine built on top of Ansible.
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

resource "git_repository_file" "awx_operator_app" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/templates/awx-operator-app.yaml"
  content = templatefile("${path.module}/templates/awx-operator-app.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "awx_operator_chart" {
  path    = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/awx-operator/Chart.yaml"
  content = templatefile("${path.module}/templates/Chart.yaml", {})
}

resource "git_repository_file" "awx_operator" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/awx-operator/templates/awx-operator.yaml"
  content = templatefile("${path.module}/templates/awx-operator.yaml.tpl", {
    tenant_name     = var.tenant_name
    environment     = var.environment
    project         = var.fleet_infra_config.argocd_project_name
    server          = var.fleet_infra_config.k8s_api_server_url
    target_revision = var.awx_config.target_revision
  })
}

resource "git_repository_file" "awx_instance" {
  count = var.awx_config.create_instance ? 1 : 0

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/awx-operator/manifests/awx-instance.yaml"
  content = templatefile("${path.module}/templates/awx-instance.yaml.tpl", {
    instance_name = var.awx_config.instance_name
    service_type  = var.awx_config.service_type
    ingress_type  = var.awx_config.ingress_type
    hostname      = var.awx_config.hostname
  })
}

resource "git_repository_file" "awx_extras" {
  count = var.awx_config.create_instance ? 1 : 0

  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/awx-operator/templates/awx-extras.yaml"
  content = templatefile("${path.module}/templates/awx-extras.yaml.tpl", {
    tenant_name = var.tenant_name
    environment = var.environment
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    repo_url    = var.fleet_infra_config.git_repo_url
    server      = var.fleet_infra_config.k8s_api_server_url
  })
}
