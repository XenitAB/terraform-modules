data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "xks" {
  name                = var.aks_name
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_user_assigned_identity" "aks_automation" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "uai-${var.aks_name}-auto"
}

resource "azurerm_role_assignment" "aks_automation" {
  scope                = data.azurerm_kubernetes_cluster.xks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_automation.principal_id
}

resource "azurerm_role_assignment" "automation_access" {
  for_each = { for id in var.automation_group_id  }

  scope                = azurerm_automation_account.aks
  role_definition_name = "Automation Operator"
  principal_id         = var.automation_group_id[each.key]
}

resource "azurerm_automation_account" "aks" {
  name                          = "auto-${var.aks_name}"
  location                      = data.azurerm_resource_group.this.location
  resource_group_name           = data.azurerm_resource_group.this.name
  public_network_access_enabled = var.aks_automation_config.public_network_access_enabled
  sku_name                      = "Basic"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_automation.id]
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_automation_runbook" "aks" {
  name                    = "AKS-StartStop"
  location                = data.azurerm_resource_group.this.location
  resource_group_name     = data.azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.aks.name
  log_verbose             = "false"
  log_progress            = "true"
  description             = "This runbook is used to start or stop a XKS cluster"
  runbook_type            = "PowerShell72"

  content = templatefile("${path.module}/scripts/aks-start-stop.ps1.tpl", {
    principal_id    = azurerm_user_assigned_identity.aks_automation.principal_id
    subscription_id = data.azurerm_subscription.current.subscription_id
  })
}

resource "azurerm_automation_schedule" "aks" {
  for_each = {
    for schedule in var.aks_automation_config.runbook_schedules :
    schedule.name => schedule
  }

  name                    = each.key
  resource_group_name     = data.azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.aks.name
  frequency               = each.value.frequency
  interval                = each.value.frequency != "OneTime" ? each.value.interval : null
  start_time              = each.value.start_time
  timezone                = each.value.timezone
  expiry_time             = each.value.expiry_time != "" ? each.value.expiry_time : null
  description             = each.value.description
  week_days               = length(each.value.week_days) != 0 ? each.value.week_days : null

  lifecycle {
    ignore_changes = [
      start_time,
    ]
  }
}

resource "azurerm_automation_job_schedule" "aks" {
  for_each = {
    for schedule in var.aks_automation_config.runbook_schedules :
    schedule.name => schedule
  }

  resource_group_name     = data.azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.aks.name
  schedule_name           = azurerm_automation_schedule.aks[each.key].name
  runbook_name            = azurerm_automation_runbook.aks.name

  # The azure job schedule rest api only supports type map[string]string for field parameters
  parameters = {
    resourcegroupname      = data.azurerm_resource_group.this.name
    aksclustername         = var.aks_name
    operation              = each.value.operation
    alertsenabled          = var.alerts_enabled
    alertresourcegroupname = var.alerts_resource_group_name
    alertname              = var.alert_name
  }
}

resource "azurerm_monitor_diagnostic_setting" "automation_account" {
  name               = "log-${var.aks_name}"
  target_resource_id = azurerm_automation_account.aks.id
  storage_account_id = var.storage_account_id

  enabled_log {
    category = "JobLogs"
  }

  enabled_log {
    category = "JobStreams"
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }
}