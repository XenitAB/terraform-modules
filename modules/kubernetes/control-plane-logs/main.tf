/**
  * # Controle plan logs
  *
  * This module is used to run a small [vector](https://vector.dev/) deployment inside the cluster.
  * It listens to a message queue, parses the output and pushes it to stdout.
  *
  * vector.toml includes the config how to connect to it's different endpoints.
  * Vector supports unit testing, and to verfiy it's config you can run `vector test vector.toml`.
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

resource "git_repository_file" "vector" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/control-plane-logs.yaml"
  content = templatefile("${path.module}/templates/vector.yaml.tpl", {
    client_id   = data.azurerm_user_assigned_identity.xenit.client_id
    tenant_name = var.tenant_name
    cluster_id  = var.cluster_id
    project     = var.fleet_infra_config.argocd_project_name
    server      = var.fleet_infra_config.k8s_api_server_url
    repo_url    = var.fleet_infra_config.git_repo_url
  })
}

resource "git_repository_file" "vector_extras" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/k8s-manifests/control-plane-logs/vector-extras.yaml"
  content = templatefile("${path.module}/templates/vector-extras.yaml.tpl", {
    azure_key_vault_name = var.azure_config.azure_key_vault_name
    client_id            = data.azurerm_user_assigned_identity.xenit.client_id
    eventhub_hostname    = var.azure_config.eventhub_hostname
    eventhub_name        = var.azure_config.eventhub_name
    tenant_id            = data.azurerm_user_assigned_identity.xenit.tenant_id
    tenant_name          = var.tenant_name
    cluster_id           = var.cluster_id
  })
}
