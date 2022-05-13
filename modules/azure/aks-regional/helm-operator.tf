resource "azuread_application" "helm_operator" {
  display_name = "${var.service_principal_name_prefix}-${var.subscription_name}-${var.environment}-${var.name}-helmoperator"
}

resource "azuread_service_principal" "helm_operator" {
  application_id = azuread_application.helm_operator.application_id
}

resource "azuread_application_password" "helm_operator" {
  application_object_id = azuread_application.helm_operator.id
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
