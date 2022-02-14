#tfsec:ignore:AZU009
resource "azurerm_kubernetes_cluster" "this" {
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

  name                            = "aks-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  location                        = data.azurerm_resource_group.this.location
  resource_group_name             = data.azurerm_resource_group.this.name
  dns_prefix                      = "aks-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  kubernetes_version              = var.aks_config.kubernetes_version
  sku_tier                        = var.aks_config.sku_tier
  api_server_authorized_ip_ranges = var.aks_authorized_ips

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

  default_node_pool {
    name           = "default"
    vnet_subnet_id = data.azurerm_subnet.this.id

    type                         = "VirtualMachineScaleSets"
    availability_zones           = ["1", "2", "3"]
    enable_auto_scaling          = false
    only_critical_addons_enabled = true

    orchestrator_version = var.aks_config.default_node_pool.orchestrator_version
    node_count           = 1
    vm_size              = "Standard_D2as_v4"

    node_labels = var.aks_config.default_node_pool.node_labels
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  for_each = {
    for nodePool in var.aks_config.additional_node_pools :
    nodePool.name => nodePool
  }

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = data.azurerm_subnet.this.id

  availability_zones  = ["1", "2", "3"]
  enable_auto_scaling = true

  os_disk_type         = each.value.os_disk_type
  os_disk_size_gb      = each.value.os_disk_size_gb
  orchestrator_version = each.value.orchestrator_version
  vm_size              = each.value.vm_size
  node_count           = each.value.min_count
  min_count            = each.value.min_count
  max_count            = each.value.max_count
  eviction_policy      = each.value.spot_enabled ? "Delete" : null
  priority             = each.value.spot_enabled ? "Spot" : "Regular"
  spot_max_price       = each.value.spot_max_price

  node_taints = each.value.spot_enabled ? concat(each.value.node_taints, ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]) : each.value.node_taints
  node_labels = each.value.spot_enabled ? merge(each.value.node_labels, { "node-pool" = each.value.name, "kubernetes.azure.com/scalesetpriority" = "spot" }) : merge(each.value.node_labels, { "node-pool" = each.value.name })
}
