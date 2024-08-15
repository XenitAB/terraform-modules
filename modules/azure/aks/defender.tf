resource "azurerm_security_center_auto_provisioning" "this" {
  auto_provision = "Off"
}

resource "azurerm_security_center_subscription_pricing" "containers" {
  for_each = {
    for s in ["defender"] :
    s => s
    if var.defender_enabled
  }

  tier          = "Standard"
  resource_type = "Containers"

  extension {
    name                            = "ContainerRegistriesVulnerabilityAssessments"
    additional_extension_properties = {}
  }

  extension {
    name                            = "AgentlessDiscoveryForKubernetes"
    additional_extension_properties = {}
  }
}

resource "azurerm_log_analytics_workspace" "xks_op" {
  name                               = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-operational"
  location                           = data.azurerm_resource_group.this.location
  resource_group_name                = data.azurerm_resource_group.this.name
  sku                                = var.defender_config.analytics_workspace.sku_name
  retention_in_days                  = var.defender_config.analytics_workspace.retention_days
  daily_quota_gb                     = var.defender_config.analytics_workspace.daily_quota_gb
  internet_ingestion_enabled         = true
  internet_query_enabled             = true
  reservation_capacity_in_gb_per_day = var.defender_config.analytics_workspace.sku_name == "CapacityReservation" ? var.defender_config.log_analytics_workspace.reservation_gb : null
}

resource "azurerm_resource_policy_assignment" "kubernetes_sensor" {
  name                 = "DefenderContainersKubernetesSensor"
  description          = "Configures AKS cluster to enable Defender profile"
  display_name         = "Defender for Containers Kubernetes sensor"
  location             = "West Europe"
  resource_id          = azurerm_kubernetes_cluster.this.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/64def556-fbad-4622-930e-72d1d5589bf5"


  parameters = <<PARAMETERS
    {
      "effect": {
        "value": ${jsonencode((var.defender_enabled && var.defender_config.kubernetes_sensor_enabled) ? local.policy_effect_deploy : local.policy_effect_disable)}
      },
      "logAnalyticsWorkspaceResourceId": {
        "value": "${azurerm_log_analytics_workspace.xks_op.id}"
      }
    } 
    PARAMETERS

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_resource_policy_assignment" "vulnerability_assessments" {
  name                 = "DefenderContainersVulnerabilityAssessment"
  description          = "Provides vulnerability management for images stored in ACR and running images in AKS clusters"
  display_name         = "Defender for Containers vulnerability management"
  location             = "West Europe"
  resource_id          = azurerm_kubernetes_cluster.this.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/efd4031d-b232-4595-babf-ae817348e91b"


  parameters = <<PARAMETERS
    {
      "effect": {
        "value": ${jsonencode((var.defender_enabled && var.defender_config.vulnerability_assessments_enabled) ? local.policy_effect_deploy : local.policy_effect_disable)}
      },
      "isContainerRegistriesVulnerabilityAssessmentsEnabled": {
        "value": ${jsonencode(var.defender_enabled && var.defender_config.vulnerability_assessments_enabled ? "true" : "false")}
      }
    } 
    PARAMETERS

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_resource_policy_assignment" "agentless_discovery" {
  name                 = "DefenderKubernetesAgentlessDiscovery"
  description          = "Provides agentless Kubernetes discovery for AKS clusters"
  display_name         = "Defender Kubernetes agentless discovery"
  location             = "West Europe"
  resource_id          = azurerm_kubernetes_cluster.this.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/72f8cee7-2937-403d-84a1-a4e3e57f3c21"

  parameters = <<PARAMETERS
    {
      "effect": {
        "value": ${jsonencode((var.defender_enabled && var.defender_config.kubernetes_discovery_enabled) ? local.policy_effect_deploy : local.policy_effect_disable)}
      },
      "isAgentlessDiscoveryForKubernetesEnabled": {
        "value": ${jsonencode(var.defender_enabled && var.defender_config.kubernetes_discovery_enabled ? "true" : "false")}
      },
      "isSensitiveDataDiscoveryEnabled": {
        "value": "false"
      },
      "isContainerRegistriesVulnerabilityAssessmentsEnabled": {
        "value": "false"
      },
      "isAgentlessVmScanningEnabled": {
        "value": "false"
      },
      "isEntraPermissionsManagementEnabled": {
        "value": "false"
      }
    } 
    PARAMETERS

  identity {
    type = "SystemAssigned"
  }
}