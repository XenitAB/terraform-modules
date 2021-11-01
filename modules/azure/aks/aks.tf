#tfsec:ignore:AZU009
resource "azurerm_kubernetes_cluster" "this" {
  name                            = "aks-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  location                        = data.azurerm_resource_group.this.location
  resource_group_name             = data.azurerm_resource_group.this.name
  dns_prefix                      = "aks-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  kubernetes_version              = var.aks_config.kubernetes_version
  sku_tier                        = var.aks_config.sku_tier
  automatic_channel_upgrade       = var.aks_config.aks_upgrade_channel
  api_server_authorized_ip_ranges = var.aks_authorized_ips

  auto_scaler_profile {
    balance_similar_node_groups      = false
    max_graceful_termination_sec     = 600
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = "0.5"
  }

  default_node_pool {
    name                         = "default"
    orchestrator_version         = var.aks_config.default_node_pool.orchestrator_version
    node_labels                  = var.aks_config.default_node_pool.node_labels
    node_count                   = 1
    vm_size                      = "Standard_D2as_v4"
    availability_zones           = ["1", "2", "3"]
    enable_auto_scaling          = false
    only_critical_addons_enabled = true
    type                         = "VirtualMachineScaleSets"
    vnet_subnet_id               = data.azurerm_subnet.this.id
    upgrade_settings {
      max_surge = 1
    }
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

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [var.aad_groups.cluster_admin.id]
    }
  }

  linux_profile {
    admin_username = "aksadmin"
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = {
    for nodePool in var.aks_config.additional_node_pools :
    nodePool.name => nodePool
  }

  name                  = each.value.name
  orchestrator_version  = each.value.orchestrator_version
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value.vm_size
  node_count            = each.value.min_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  enable_auto_scaling   = true
  vnet_subnet_id        = data.azurerm_subnet.this.id


  node_taints = each.value.node_taints

  node_labels = merge({
    "node-pool" = each.value.name
    },
    each.value.node_labels
  )

  availability_zones = [
    "1",
    "2",
    "3"
  ]

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
  upgrade_settings {
    max_surge = each.value.max_surge
  }
}
