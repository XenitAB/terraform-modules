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
      version = "3.107.0"
      source  = "hashicorp/azurerm"
    }
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "kustomization" {
  path = "clusters/${var.cluster_id}/trivy.yaml"
  content = templatefile("${path.module}/templates/kustomization.yaml.tpl", {
    cluster_id = var.cluster_id,
  })
}

resource "git_repository_file" "trivy_operator" {
  path = "platform/${var.cluster_id}/trivy/trivy-operator.yaml"
  content = templatefile("${path.module}/templates/trivy-operator.yaml.tpl", {
    client_id = azurerm_user_assigned_identity.trivy.client_id,
  })
}

resource "git_repository_file" "trivy" {
  path = "platform/${var.cluster_id}/trivy/trivy.yaml"
  content = templatefile("${path.module}/templates/trivy.yaml.tpl", {
    client_id                       = azurerm_user_assigned_identity.trivy.client_id,
    volume_claim_storage_class_name = var.volume_claim_storage_class_name,
  })
}

resource "git_repository_file" "starboard_eporter" {
  for_each = {
    for s in ["starboard_eporter"] :
    s => s
    if var.starboard_exporter_enabled
  }

  path = "platform/${var.cluster_id}/trivy/starboard-eporter.yaml"
  content = templatefile("${path.module}/templates/starboard-exporter.yaml.tpl", {
  })
}
