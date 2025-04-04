data "azuread_group" "all_owner" {
  display_name = var.argocd_config.aad_group_name
}

resource "azuread_application" "dex" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if length(var.argocd_config.azure_tenants) > 0
  }

  display_name = "ArgoCD Dex connector for XKS management cluster"

  app_role {
    allowed_member_types = ["User"]
    description          = "Only members of all owner group have access "
    display_name         = "Admins"
    enabled              = true
    id                   = data.azuread_group.all_owner.id
    value                = "admin"
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }

    resource_access {
      id   = "b4e74841-8e56-480b-be8b-910348b18b4c" # User.ReadWrite
      type = "Scope"
    }
  }

  web {
    redirect_uris = ["https://${var.argocd_config.global_domain}/api/dex/callback"]
  }
}

resource "azuread_application_password" "dex" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if length(var.argocd_config.azure_tenants) > 0
  }

  application_id = azuread_application.dex["argocd"].id
  end_date       = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}