/**
  * # RabbitMQ Operator
  *
  * This module is used to add [`rabbitmq-operator`](https://www.rabbitmq.com/kubernetes/operator/operator-overview) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "rabbitmq_operator" {
  path = "platform/${var.tenant_name}/${var.cluster_id}/argocd-applications/rabbitmq-operator.yaml"
  content = templatefile("${path.module}/templates/rabbitmq-operator.yaml.tpl", {
    min_available           = var.rabbitmq_config.min_available
    replica_count           = var.rabbitmq_config.replica_count
    network_policy_enabled  = var.rabbitmq_config.network_policy_enabled
    spot_instances_enabled  = var.rabbitmq_config.spot_instances_enabled
    tology_operator_enabled = var.rabbitmq_config.tology_operator_enabled
    watch_namespaces        = var.rabbitmq_config.watch_namespaces
  })
}