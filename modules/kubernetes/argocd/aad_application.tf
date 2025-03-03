resource "azuread_application" "dex" {
  display_name = "ArgoCD Dex connector"
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