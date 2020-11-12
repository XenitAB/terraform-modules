resource "azurerm_kubernetes_cluster" "aks" {
  name                            = "aks-${var.environmentShort}-${var.locationShort}-${var.commonName}"
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  dns_prefix                      = "aks-${var.environmentShort}-${var.locationShort}-${var.commonName}"
  kubernetes_version              = var.aksConfiguration.kubernetes_version
  sku_tier                        = var.aksConfiguration.sku_tier
  api_server_authorized_ip_ranges = local.aksAuthorizedIps

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
    name                 = "default"
    orchestrator_version = var.aksConfiguration.default_node_pool.orchestrator_version
    node_count           = var.aksConfiguration.default_node_pool.min_count
    min_count            = var.aksConfiguration.default_node_pool.min_count
    max_count            = var.aksConfiguration.default_node_pool.max_count
    vm_size              = var.aksConfiguration.default_node_pool.vm_size
    node_labels = merge({
      "node-pool" = "default"
      },
      var.aksConfiguration.default_node_pool.node_labels
    )

    availability_zones  = ["1", "2", "3"]
    enable_auto_scaling = true
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = data.azurerm_subnet.subnet.id
  }

  network_profile {
    network_plugin    = "kubenet"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    load_balancer_profile {
      outbound_ip_prefix_ids = [
        local.aksPipPrefixId
      ]
    }
  }

  service_principal {
    client_id     = local.aksAadApps.aksClientAppClientId
    client_secret = local.aksAadApps.aksClientAppClientSecret
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      client_app_id     = local.aksAadApps.aksClientAppClientId
      server_app_id     = local.aksAadApps.aksServerAppClientId
      server_app_secret = local.aksAadApps.aksServerAppClientSecret
    }
  }

  linux_profile {
    admin_username = "aksadmin"
    ssh_key {
      key_data = jsondecode(data.azurerm_key_vault_secret.secretSshKey.value).public_key_openssh
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "aksNodePools" {
  for_each = {
    for nodePool in var.aksConfiguration.additional_node_pools :
    nodePool.name => nodePool
  }

  name                  = each.value.name
  orchestrator_version  = each.value.orchestrator_version
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  node_count            = each.value.min_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  enable_auto_scaling   = true
  vnet_subnet_id        = data.azurerm_subnet.subnet.id

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
}
