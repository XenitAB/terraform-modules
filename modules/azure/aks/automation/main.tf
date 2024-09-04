data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "xks" {
  name                = var.aks_name
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azuread_group" "automation_access" {
  display_name     = "az-auto-${var.aks_name}-operator"
  security_enabled = true
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
  scope                = azurerm_automation_account.aks.id
  role_definition_name = "Automation Operator"
  principal_id         = azuread_group.automation_access.id
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

resource "azurerm_monitor_action_group" "xks" {
  for_each = {
    for s in ["automation"] :
    s => s
    if var.aks_automation_config.alerts_config.enabled
  }

  name                = "${azurerm_automation_runbook.aks.name}-Failed-Action"
  resource_group_name = data.azurerm_resource_group.this.name
  short_name          = "aks-action-1"

  dynamic "email_receiver" {
    for_each = var.aks_automation_config.alerts_config.email_to != "" ? [""] : []

    content {
      name          = "sendtoadmin"
      email_address = var.aks_automation_config.alerts_config.email_to
    }
  }

  # Always send to Xenit
  email_receiver {
    name          = "sendtoxenit"
    email_address = var.notification_email
  }
}

resource "azurerm_monitor_metric_alert" "xks" {
  for_each = {
    for s in ["automation"] :
    s => s
    if var.aks_automation_config.alerts_config.enabled
  }

  name                = "${azurerm_automation_runbook.aks.name}-alert"
  resource_group_name = data.azurerm_resource_group.this.name
  scopes              = [azurerm_automation_account.aks.id]
  description         = "Action will be triggered when runbook job fails"
  frequency           = var.aks_automation_config.alerts_config.frequency
  window_size         = var.aks_automation_config.alerts_config.window_size
  severity            = var.aks_automation_config.alerts_config.severity

  criteria {
    metric_namespace = "Microsoft.Automation/automationAccounts"
    metric_name      = "TotalJob"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "Runbook"
      operator = "Include"
      values   = [azurerm_automation_runbook.aks.name]
    }

    dimension {
      name     = "Status"
      operator = "Include"
      values   = ["Failed"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.xks["automation"].id
  }
}