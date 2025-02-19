/**
  * # Karpenter (karpenter)
  *
  * This module is used to add self-hosted [`karpenter`](https://github.com/Azure/karpenter-provider-azure) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.7.0"
      source  = "hashicorp/azurerm"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.16.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}

resource "kubectl_manifest" "secret" {
  server_side_apply = true
  apply_only        = true
  yaml_body = templatefile("${path.module}/templates/secret.yaml.tpl", {
    bootstrap_token = base64encode(var.aks_config.bootstrap_token)
  })
}

resource "helm_release" "karpenter" {
  depends_on = [kubectl_manifest.secret]

  repository  = "oci://mcr.microsoft.com/aks/karpenter/"
  chart       = "karpenter"
  name        = "karpenter"
  namespace   = "kube-system"
  version     = "0.7.2"
  max_history = 3
  skip_crds   = false
  wait        = true
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    default_node_pool_size   = var.aks_config.default_node_pool_size
    batch_idle_duration      = var.karpenter_config.settings.batch_idle_duration
    batch_max_duration       = var.karpenter_config.settings.batch_max_duration
    client_id                = azurerm_user_assigned_identity.karpenter.client_id,
    cluster_endpoint         = var.aks_config.cluster_endpoint
    cluster_name             = var.aks_config.cluster_name
    location                 = var.location
    node_identities          = var.aks_config.node_identities
    node_resource_group_name = var.aks_config.node_resource_group
    replica_count            = var.karpenter_config.replica_count
    ssh_public_key           = var.aks_config.ssh_public_key
    subscription_id          = var.subscription_id
    vnet_subnet_id           = var.aks_config.vnet_subnet_id
  })]
}

# Wait a while to make sure karpenter webhooks get created
resource "time_sleep" "wait_for_karpenter" {
  depends_on = [helm_release.karpenter]

  create_duration = "15s"
}

resource "kubectl_manifest" "node_classes" {
  depends_on = [time_sleep.wait_for_karpenter]
  for_each = {
    for class in var.karpenter_config.node_classes :
    class.name => class
  }

  server_side_apply = true
  apply_only        = true
  yaml_body = templatefile("${path.module}/templates/node-classes.yaml.tpl", {
    class = each.value
  })
}

resource "kubectl_manifest" "node_pools" {
  depends_on = [kubectl_manifest.node_classes]
  for_each = {
    for pool in var.karpenter_config.node_pools :
    pool.name => pool
  }

  server_side_apply = true
  apply_only        = true
  yaml_body = templatefile("${path.module}/templates/node-pools.yaml.tpl", {
    pool = each.value
  })
}