resource "azuread_application" "helm_operator" {
  name = "${var.service_principal_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${var.name}${var.group_name_separator}helmoperator"
}

resource "azuread_service_principal" "helm_operator" {
  application_id = azuread_application.helm_operator.application_id
}

resource "random_password" "helm_operator" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.helm_operator.id
  }
}

resource "azuread_application_password" "helm_operator" {
  application_object_id = azuread_application.helm_operator.id
  value                 = random_password.helm_operator.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "azuread_group_member" "helm_operator" {
  group_object_id  = data.azuread_group.acr_pull.id
  member_object_id = azuread_service_principal.helm_operator.object_id
}
