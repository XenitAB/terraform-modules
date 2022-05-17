output "azuread_service_principal_object_id" {
  description = "The group id of azure ad group edit"
  value = {
    for sp in azuread_service_principal.aad_sp :
    sp.key => sp.object_id
  }
}

output "azuread_groups" {
  description = "Output for Azure AD Groups"
  value = {
    sub_owner = {
      id = azuread_group.sub_owner.id
    }
    sub_contributor = {
      id = azuread_group.sub_contributor.id
    }
    sub_reader = {
      id = azuread_group.sub_reader.id
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
        application_id              = value.application_id
        service_principal_object_id = azuread_service_principal.delegate_kv_aad[key].id
      }
    }
    rg_contributor = {
      for key, value in azuread_application.aad_app :
      key => {
        display_name                = value.display_name
        application_object_id       = value.id
        application_id              = value.application_id
        service_principal_object_id = azuread_service_principal.aad_sp[key].id
      }
    }
    sub_reader = {
      display_name                = azuread_application.sub_reader_sp.display_name
      application_object_id       = azuread_application.sub_reader_sp.id
      application_id              = azuread_application.sub_reader_sp.application_id
      service_principal_object_id = azuread_service_principal.sub_reader_sp.id
    }
  }
}
