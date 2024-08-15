output "azuread_groups" {
  description = "Output for Azure AD Groups"
  value = {
    rg_owner = {
      for key, value in azuread_group.rg_owner :
      key => {
        id = value.id
      }
    }
    rg_contributor = {
      for key, value in azuread_group.rg_contributor :
      key => {
        id = value.id
      }
    }
    rg_reader = {
      for key, value in azuread_group.rg_reader :
      key => {
        id = value.id
      }
    }
    sub_owner = {
      id = azuread_group.sub_owner.id
    }
    sub_contributor = {
      id = azuread_group.sub_contributor.id
    }
    sub_reader = {
      id = azuread_group.sub_reader.id
    }
    service_endpoint_join = {
      id = azuread_group.service_endpoint_join.id
    }
  }
}

output "azuread_apps" {
  description = "Output for Azure AD applications"
  value = {
    delegate_kv = {
      for key, value in azuread_application.delegate_kv_aad :
      key => {
        display_name                = value.display_name
        application_object_id       = value.id
        client_id                   = value.client_id
        service_principal_object_id = azuread_service_principal.delegate_kv_aad[key].id
      }
    }
    rg_contributor = {
      for key, value in azuread_application.aad_app :
      key => {
        display_name                = value.display_name
        application_object_id       = value.id
        client_id                   = value.client_id
        service_principal_object_id = azuread_service_principal.aad_sp[key].id
      }
    }
    sub_reader = {
      display_name                = azuread_application.sub_reader_sp.display_name
      application_object_id       = azuread_application.sub_reader_sp.id
      client_id                   = azuread_application.sub_reader_sp.client_id
      service_principal_object_id = azuread_service_principal.sub_reader_sp.id
    }
  }
}

output "aad_sp_passwords" {
  description = "Application password per resource group."
  value = {
    for key, value in azuread_application_password.aad_sp :
    key => value.value
  }
}
