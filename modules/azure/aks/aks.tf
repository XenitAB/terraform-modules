# azure-container-use-rbac-permissions is ignored because the rule has not been updated in tfsec
#tfsec:ignore:azure-container-limit-authorized-ips tfsec:ignore:azure-container-logging tfsec:ignore:azure-container-use-rbac-permissions
resource "azurerm_kubernetes_cluster" "this" {
  name                            = "aks-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  location                        = data.azurerm_resource_group.this.location
  resource_group_name             = data.azurerm_resource_group.this.name
  dns_prefix                      = "aks-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  kubernetes_version              = var.aks_config.version
  sku_tier                        = var.aks_config.production_grade ? "Paid" : "Free"
  api_server_authorized_ip_ranges = var.aks_authorized_ips
  run_command_enabled             = false

  auto_scaler_profile {
    # Pods should not depend on local storage like EmptyDir or HostPath
    skip_nodes_with_local_storage = false
    # Selects the node pool which would result in the least amount of waste.
    # TODO: When supported we should make use of multiple expanders #499
    expander = "least-waste"
  }

  network_profile {
    network_plugin    = "kubenet"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    load_balancer_profile {
      outbound_ip_prefix_ids = [
        var.aks_public_ip_prefix_id
      ]
    }
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [var.aad_groups.cluster_admin.id]
  }

  linux_profile {
    admin_username = "aksadmin"
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  default_node_pool {
    name           = "default"
    vnet_subnet_id = data.azurerm_subnet.this.id
    zones          = ["1", "2", "3"]

    orchestrator_version = var.aks_config.version
    # This is a bug in tflint
    # tflint-ignore: azurerm_kubernetes_cluster_default_node_pool_invalid_vm_size
    vm_size                      = var.aks_default_node_pool_vm_size
    os_disk_type                 = "Ephemeral"
    os_disk_size_gb              = local.vm_skus_disk_size_gb[var.aks_default_node_pool_vm_size]
    enable_auto_scaling          = false
    node_count                   = var.aks_config.production_grade ? 2 : 1
    only_critical_addons_enabled = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  name                       = "log-analytics-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  target_resource_id         = azurerm_kubernetes_cluster.this.id
  log_analytics_workspace_id = var.log_analytics_id

  log {
    category = "kube-scheduler"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "cloud-controller-manager"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "csi-azurefile-controller"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "csi-snapshot-controller"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "csi-azuredisk-controller"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "guard"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  log {
    category = "kube-audit"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "kube-audit-admin"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  log {
    category = "kube-apiserver"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 7
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_storage_account" {
  name               = "storage-account-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  target_resource_id = azurerm_kubernetes_cluster.this.id
  storage_account_id = var.log_storage_account_id

  log {
    category = "kube-scheduler"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "cloud-controller-manager"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "csi-azurefile-controller"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "csi-snapshot-controller"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "csi-azuredisk-controller"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "guard"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  log {
    category = "kube-audit-admin"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "kube-apiserver"
    enabled  = false
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = {
    for nodePool in var.aks_config.node_pools :
    nodePool.name => nodePool
  }

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = data.azurerm_subnet.this.id
  zones                 = ["1", "2", "3"]

  enable_auto_scaling  = true
  os_disk_type         = "Ephemeral"
  os_disk_size_gb      = local.vm_skus_disk_size_gb[each.value.vm_size]
  orchestrator_version = each.value.version
  vm_size              = each.value.vm_size
  min_count            = each.value.min_count
  max_count            = each.value.max_count
  eviction_policy      = each.value.spot_enabled ? "Delete" : null
  priority             = each.value.spot_enabled ? "Spot" : "Regular"
  spot_max_price       = each.value.spot_max_price

  node_taints = each.value.node_taints
  node_labels = merge({ "xkf.xenit.io/node-ttl" = "168h" }, each.value.node_labels, { "node-pool" = each.value.name })

  upgrade_settings {
    max_surge = "33%"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Replace this with a datasource when availible in the AzureRM provider.
locals {
  vm_skus_disk_size_gb = {
    "Standard_D2ds_v5"  = 75
    "Standard_D4ds_v5"  = 150
    "Standard_D8ds_v5"  = 300
    "Standard_D16ds_v5" = 600
    "Standard_D32ds_v5" = 1200
    "Standard_D48ds_v5" = 1800
    "Standard_D64ds_v5" = 2400
    "Standard_D96ds_v5" = 3600

    "Standard_D2ads_v5"  = 75
    "Standard_D4ads_v5"  = 150
    "Standard_D8ads_v5"  = 300
    "Standard_D16ads_v5" = 600
    "Standard_D32ads_v5" = 1200
    "Standard_D48ads_v5" = 1800
    "Standard_D64ads_v5" = 2400
    "Standard_D96ads_v5" = 3600

    "Standard_E2ds_v5"   = 75
    "Standard_E4ds_v5"   = 150
    "Standard_E8ds_v5"   = 300
    "Standard_E16ds_v5"  = 600
    "Standard_E20ds_v5"  = 750
    "Standard_E32ds_v5"  = 1200
    "Standard_E48ds_v5"  = 1800
    "Standard_E64ds_v5"  = 2400
    "Standard_E96ds_v5"  = 3600
    "Standard_E104ds_v5" = 3800

    "Standard_E2ads_v5"  = 75
    "Standard_E4ads_v5"  = 150
    "Standard_E8ads_v5"  = 300
    "Standard_E16ads_v5" = 600
    "Standard_E20ads_v5" = 750
    "Standard_E32ads_v5" = 1200
    "Standard_E48ads_v5" = 1800
    "Standard_E64ads_v5" = 2400
    "Standard_E96ads_v5" = 3600

    "Standard_F2s_v2"  = 32
    "Standard_F4s_v2"  = 64
    "Standard_F8s_v2"  = 128
    "Standard_F16s_v2" = 256
    "Standard_F32s_v2" = 512
    "Standard_F48s_v2" = 768
    "Standard_F64s_v2" = 1024
    "Standard_F72s_v2" = 1520
  }
}
