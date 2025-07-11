data "azuread_group" "all_owner" {
  display_name = var.argocd_config.aad_group_name
}

resource "azuread_application" "dex" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if contains(["Hub", "Hub-Spoke"], var.argocd_config.cluster_role)
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
    redirect_uris = formatlist("https://%s/api/dex/callback", split(",", var.argocd_config.dex_redirect_domains))
  }
}

resource "azuread_application_password" "dex" {
  for_each = {
    for s in ["argocd"] :
    s => s
    if contains(["Hub", "Hub-Spoke"], var.argocd_config.cluster_role)
  }

  application_id = azuread_application.dex["argocd"].id
  end_date       = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}