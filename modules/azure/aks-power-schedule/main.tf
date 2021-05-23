/**
  * # Azure Kubernetes Service Power Schedule
  *
  * Levrage Azure Functions (consumption plan) to create a cron job (time trigger) to handle AKS power schedule.
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
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

data "azurerm_subscription" "this" {}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name == "" ? "rg-${var.environment}-${var.location_short}-${var.name}" : var.resource_group_name
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

data "local_file" "this" {
  for_each = local.function_files
  filename = each.value.source_path
}

data "template_file" "this" {
  for_each = local.template_files
  template = file(each.value.source_path)

  vars = {
    shutdown_aks_cron_expression = var.shutdown_aks_cron_expression
    shutdown_aks_disabled        = var.shutdown_aks_disabled
  }
}

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

resource "azurerm_storage_account" "this" {
  name                     = "strg${var.environment}${var.location_short}${var.name}fn${var.unique_suffix}"
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
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

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true",
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "AzureWebJobsDisableHomepage"    = "true",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.this.instrumentation_key,
    "WEBSITE_NODE_DEFAULT_VERSION"   = "~14",
    "AZURE_SUBSCRIPTION_ID"          = data.azurerm_subscription.this.subscription_id,
    "AZURE_RESOURCE_NAME_FILTER"     = var.aks_cluster_name
  }
}

resource "azurerm_role_assignment" "this" {
  scope = data.azurerm_resource_group.this.id

  # Can't find any roles that allow the specific action to stop a cluster
  role_definition_name = "Contributor"

  principal_id = azurerm_function_app.this.identity[0].principal_id
}

resource "null_resource" "this" {
  depends_on = [azurerm_function_app.this]

  provisioner "local-exec" {
    command = <<EOT
      attempt_counter=0
      max_attempts=10

      until $(curl --silent --fail -X POST --user $DEPLOYMENT_USER --data-binary @$BINARY_DATA_PATH $URL); do
          if [ $attempt_counter -eq $max_attempts ];then
            echo "Max attempts reached"
            exit 1
          fi

          printf '.'
          attempt_counter=$(($attempt_counter+1))
          sleep $(($attempt_counter*5))
      done
EOT

    environment = {
      DEPLOYMENT_USER  = "${azurerm_function_app.this.site_credential[0].username}:${azurerm_function_app.this.site_credential[0].password}"
      BINARY_DATA_PATH = data.archive_file.this.output_path
      URL              = "https://${azurerm_function_app.this.name}.scm.azurewebsites.net/api/zipdeploy?isAsync=true"
    }
  }

  triggers = {
    "archive_sha"     = data.archive_file.this.output_sha
    "deployment_user" = "${azurerm_function_app.this.site_credential[0].username}:${azurerm_function_app.this.site_credential[0].password}"
  }
}
