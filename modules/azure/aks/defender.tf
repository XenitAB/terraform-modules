resource "azurerm_security_center_subscription_pricing" "kubernetes" {
  count         = (var.defender_enabled && var.defender_config.kubernetes_sensor_enabled) ? 1 : 0
  tier          = "Standard"
  resource_type = "KubernetesService"
}

resource "azurerm_security_center_subscription_pricing" "containers" {
  count         = (var.defender_enabled && var.defender_config.vulnerability_assessments_enabled) ? 1 : 0
  tier          = "Standard"
  resource_type = "Containers"
}

resource "azurerm_security_center_subscription_pricing" "container_registry" {
  count         = (var.defender_enabled && var.defender_config.vulnerability_assessments_enabled) ? 1 : 0
  tier          = "Standard"
  resource_type = "ContainerRegistry"
}

resource "azurerm_security_center_subscription_pricing" "cspm" {
  count         = (var.defender_enabled && var.defender_config.kubernetes_discovery_enabled) ? 1 : 0
  tier          = "Standard"
  resource_type = "CloudPosture"

  extension {
    name = "AgentlessDiscoveryForKubernetes"
  }
}

resource "azurerm_log_analytics_workspace" "xks_op_standard" {
  count                      = (var.defender_enabled && var.defender_config.log_analytics_workspace.sku_name != "PerGB2018") ? 1 : 0
  name                       = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-op"
  location                   = data.azurerm_resource_group.this.location
  resource_group_name        = data.azurerm_resource_group.this.name
  sku                        = var.defender_config.log_analytics_workspace.sku_name
  retention_in_days          = var.defender_config.log_analytics_workspace.retention_days
  daily_quota_gb             = var.defender_config.log_analytics_workspace.daily_quota_gb
  internet_ingestion_enabled = false
  internet_query_enabled     = false

  #identity {
  #  type = SystemAssigned 
  #}
}

resource "azurerm_log_analytics_workspace" "xks_op_reserved" {
  count                      = (var.defender_enabled && var.defender_config.log_analytics_workspace.sku_name == "CapacityReservation") ? 1 : 0
  name                       = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-op"
  location                   = data.azurerm_resource_group.this.location
  resource_group_name        = data.azurerm_resource_group.this.name
  sku                        = var.defender_config.log_analytics_workspace.sku_name
  retention_in_days          = var.defender_config.log_analytics_workspace.retention_days
  daily_quota_gb             = var.defender_config.log_analytics_workspace.daily_quota_gb
  internet_ingestion_enabled = false
  internet_query_enabled     = false

  reservation_capacity_in_gb_per_day = var.defender_config.log_analytics_workspace.reservation_gb
  
  #identity {
  #  type = SystemAssigned 
  #}
}

resource "azurerm_resource_policy_assignment" "kubernetes_sensor" {
  name                 = "DefenderContainersKubernetesSensor"
  description          = "Configures AKS cluster to enable Defender profile"
  display_name         = "Defender for Containers Kubernetes sensor"
  resource_id          = azurerm_kubernetes_cluster.this.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/64def556-fbad-4622-930e-72d1d5589bf5"
  
  
  parameters =  <<PARAMETERS
    {
      "effect": {
        "value": ${(var.defender_enabled && var.defender_config.kubernetes_sensor_enabled) ? "DeployIfNotExists" : "Disabled"}
      },
      "logAnalyticsWorkspaceResourceId": {
        "value": "${var.defender_config.log_analytics_workspace.sku_name == "CapacityReservation" ? azurerm_log_analytics_workspace.xks_op_standard.id : azurerm_log_analytics_workspace.xks_op_reserved.id}"
      }
    } 
    PARAMETERS
}

resource "azurerm_resource_policy_assignment" "vulnerability_assessments" {
  name                 = "DefenderContainersVulnerabilityAssessment"
  description          = "Provides vulnerability management for images stored in ACR and running images in AKS clusters"
  display_name         = "Defender for Containers vulnerability mangement"
  resource_id          = azurerm_kubernetes_cluster.this.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/efd4031d-b232-4595-babf-ae817348e91b"
  
  
  parameters =  <<PARAMETERS
    {
      "effect": {
        "value": ${(var.defender_enabled && var.defender_config.vulnerability_assessments_enabled) ? "DeployIfNotExists" : "Disabled"}
      }
      "isAgentlessDiscoveryForKubernetesEnabled": {
        "value": "${var.defender_enabled && var.defender_config.vulnerability_assessments_enabled ? true : false}"
      }
    } 
    PARAMETERS
}

resource "azurerm_resource_policy_assignment" "agentless_discovery" {
  name                 = "DefenderKubernetesAgentlessDiscovery"
  description          = "Provides agentless Kubernetes discovery for AKS clusters"
  display_name         = "Defender Kubernetes agentless discovery"
  resource_id          = azurerm_kubernetes_cluster.this.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/72f8cee7-2937-403d-84a1-a4e3e57f3c21"
  
  
  parameters =  <<PARAMETERS
    {
      "effect": {
        "value": ${(var.defender_enabled && var.defender_config.kubernetes_discovery_enabled) ? "DeployIfNotExists" : "Disabled"}
      }
      "isContainerRegistriesVulnerabilityAssessmentsEnabled": {
        "value": "${var.defender_enabled && var.defender_config.kubernetes_discovery_enabled ? true : false}"
      }
    } 
    PARAMETERS
}