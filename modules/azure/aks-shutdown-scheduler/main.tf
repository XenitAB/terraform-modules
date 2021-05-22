/**
  * # Azure Kubernetes Service Shutdown Scheduler
  *
  * Levrage Azure Functions (consumption plan) to create a cron job (time trigger) to shutdown a specific AKS cluster on a schedule.
  *
  * # Using module locally
  *
  * You may have to delete the `tmp` folder between local runs if it fails with an error like:
  * `could not generate output checksum: archive/tar: write too long`
  *
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    azurerm = {
      version = "2.59.0"
      source  = "hashicorp/azurerm"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.7.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name == "" ? "rg-${var.environment}-${var.location_short}-${var.name}" : var.resource_group_name
}

resource "azurerm_storage_account" "this" {
  name                     = "strg${var.environment}${var.location_short}${var.name}fn${var.unique_suffix}"
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_app_service_plan" "this" {
  name                = "svcplan-${var.environment}-${var.location_short}-${var.name}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  kind                = "Linux"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  lifecycle {
    ignore_changes = [
      kind
    ]
  }
}

resource "azurerm_storage_container" "this" {
  name                  = "functions"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

locals {
  function_files = { for function_file in fileset("${path.module}/functions", "**") :
    function_file => {
      destination_path = function_file
      source_path      = "${path.module}/functions/${function_file}"
    }
  }
  template_files = { for template_file in fileset("${path.module}/templates", "**") :
    template_file => {
      destination_path = template_file
      source_path      = "${path.module}/templates/${template_file}"
    }
  }
}

output "function_files" {
  description = "Function files"
  value       = local.function_files
}

output "template_files" {
  description = "Template files"
  value       = local.template_files
}

data "local_file" "this" {
  for_each = local.function_files
  filename = each.value.source_path
}

data "template_file" "this" {
  for_each = local.template_files
  template = file(each.value.source_path)

  vars = {
    cron_expression = var.shutdown_aks_cron_expression
  }
}

# This is only used to trigger null_resource.this in case of files changed inside of the functions folder
data "archive_file" "this" {
  type        = "zip"
  output_path = "${path.module}/tmp/functions.zip"

  dynamic "source" {
    for_each = local.function_files
    content {
      content  = data.local_file.this[source.key].content
      filename = source.value.destination_path
    }
  }

  dynamic "source" {
    for_each = local.template_files
    content {
      content  = data.template_file.this[source.key].rendered
      filename = source.value.destination_path
    }
  }
}

resource "azurerm_storage_blob" "this" {
  name                   = "${data.archive_file.this.output_sha}.zip"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  source                 = data.archive_file.this.output_path
}

resource "time_rotating" "this" {
  rotation_hours = 43800 # 5 years
}

data "azurerm_storage_account_blob_container_sas" "this" {
  connection_string = azurerm_storage_account.this.primary_connection_string
  container_name    = azurerm_storage_container.this.name

  start  = time_rotating.this.rfc3339
  expiry = timeadd(time_rotating.this.rotation_rfc3339, "87600h") # 10 years

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

resource "azurerm_application_insights" "this" {
  name                = "ai-${var.environment}-${var.location_short}-${var.name}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  application_type    = "web"
}

resource "azurerm_function_app" "this" {
  name                       = join("-", compact(["fn-${var.environment}-${var.location_short}-${var.name}", var.unique_suffix]))
  resource_group_name        = data.azurerm_resource_group.this.name
  location                   = data.azurerm_resource_group.this.location
  app_service_plan_id        = azurerm_app_service_plan.this.id
  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key
  version                    = "~3"
  os_type                    = "linux"

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true",
    "ENABLE_ORYX_BUILD"              = "true",
    "WEBSITE_RUN_FROM_PACKAGE"       = "${azurerm_storage_blob.this.url}${data.azurerm_storage_account_blob_container_sas.this.sas}",
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "AzureWebJobsDisableHomepage"    = "true",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.this.instrumentation_key,
    "WEBSITE_NODE_DEFAULT_VERSION"   = "~14",
    "FUNCTION_APP_EDIT_MODE"         = "readonly",
    "HASH"                           = data.archive_file.this.output_sha
  }
}
