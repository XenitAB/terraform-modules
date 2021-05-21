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
      source = "hashicorp/local"
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
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_container" "this" {
  name                  = "functions"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

data "template_file" "shutdown_aks_function_json" {
  template = "${file("${path.module}/templates/shutdown_aks_function.json.tpl")}"
  vars = {
    cron_expression = var.shutdown_aks_cron_expression
  }
}

resource "local_file" "shutdown_aks_function_json" {
    content     = data.template_file.shutdown_aks_function_json.rendered
    filename = "${path.module}/tmp/functions/ShutdownAKS/function.json"
}

# This is only used to trigger null_resource.this in case of files changed inside of the functions folder
data "archive_file" "dummy" {
  type        = "zip"
  source_dir = "${path.module}/functions"
  output_path = "${path.module}/tmp/dummy.zip"
}

resource "null_resource" "this" {
  depends_on = [local_file.shutdown_aks_function_json, data.archive_file.dummy]
  
  provisioner "local-exec" {
    command = "cd ${path.module}/functions && ./terraform-deploy.sh"
  }

  triggers = {
    "functions" = data.archive_file.dummy.output_sha
    "shutdown_aks_function_json" = sha256(data.template_file.shutdown_aks_function_json.rendered)
  }
}

locals {
  archive_file_path = "${path.module}/tmp/functions.zip"
}

resource "azurerm_storage_blob" "this" {
  depends_on = [null_resource.this]
  name                   = "${filesha256(local.archive_file_path)}.zip"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  source                 = local.archive_file_path
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

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"       = "${azurerm_storage_blob.this.url}${data.azurerm_storage_account_blob_container_sas.this.sas}",
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "AzureWebJobsDisableHomepage"    = "true",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.this.instrumentation_key,
    "WEBSITE_NODE_DEFAULT_VERSION"   = "~14",
    "FUNCTION_APP_EDIT_MODE"         = "readonly",
    "HASH"                           = filesha256(local.archive_file_path)
  }
}