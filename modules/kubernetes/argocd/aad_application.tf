data "azuread_group" "all_owner" {
  display_name = var.argocd_config.aad_group_name
}

resource "azuread_application" "dex" {
  display_name = "ArgoCD Dex connector"

  app_role {
    allowed_member_types = ["User"]
    description          = "Only members of all owner group have access "
    display_name         = "Admins"
    enabled              = true
    id                   = data.azuread_group.all_owner.id
    value                = "admin"
  }

  web {
    redirect_uris = ["https://${var.argocd_config.global_domain}/api/dex/callback"]
  }
}

resource "azuread_application_password" "dex" {
  application_id = azuread_application.dex.id
  end_date       = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}