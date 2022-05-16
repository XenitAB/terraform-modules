# More info about Azure Container Registry Roles can be found here: https://docs.microsoft.com/en-us/azure/container-registry/container-registry-roles

# ACR Push Azure AD group will grant push and pull permissions to the Container Registry
resource "azuread_group" "acr_push" {
  for_each = {
    for s in ["delegate_acr"] :
    s => s
    if var.delegate_acr
  }

  display_name            = "${var.aks_group_name_prefix}-${var.subscription_name}-${var.environment}-${var.location_short}-acrpush"
  prevent_duplicate_names = true
  security_enabled        = true
}

# ACR Pull Azure AD group will grant pull permissions to the Container Registry
resource "azuread_group" "acr_pull" {
  for_each = {
    for s in ["delegate_acr"] :
    s => s
    if var.delegate_acr
  }

  display_name            = "${var.aks_group_name_prefix}-${var.subscription_name}-${var.environment}-${var.location_short}-acrpull"
  prevent_duplicate_names = true
  security_enabled        = true
}

# ACR Reader Azure AD group will grant ARM (to view Container Registry in Azure Portal) and pull permissions to the Container Registry
resource "azuread_group" "acr_reader" {
  for_each = {
    for s in ["delegate_acr"] :
    s => s
    if var.delegate_acr
  }

  display_name            = "${var.aks_group_name_prefix}-${var.subscription_name}-${var.environment}-${var.location_short}-acrreader"
  prevent_duplicate_names = true
  security_enabled        = true
}

# Grant ACR Push permissions to the resource group service principal
resource "azuread_group_member" "acr_spn" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_push["delegate_acr"].id
  member_object_id = var.service_principal_object_id[each.key]
}

# Grant ACR Push permissions to the resource group owners
resource "azuread_group_member" "acr_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_push["delegate_acr"].id
  member_object_id = azuread_group.rg_owner[each.key].id
}

# Grant ACR Push permissions to the resource group contributors
resource "azuread_group_member" "acr_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_push["delegate_acr"].id
  member_object_id = azuread_group.rg_contributor[each.key].id
}

# Grant ACR Pull permissions to the resource group readers
# This is now redundant since ACR Reader also grants Pull permissions, but kept for backward compatibility
resource "azuread_group_member" "acr_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_pull["delegate_acr"].id
  member_object_id = azuread_group.rg_reader[each.key].id
}

# Grant ACR Reader permissions to the resource group owners
resource "azuread_group_member" "acr_reader_rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_reader["delegate_acr"].id
  member_object_id = azuread_group.rg_owner[each.key].id
}

# Grant ACR Reader permissions to the resource group contributors
resource "azuread_group_member" "acr_reader_rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_reader["delegate_acr"].id
  member_object_id = azuread_group.rg_contributor[each.key].id
}

# Grant ACR Reader permissions to the resource group readers
resource "azuread_group_member" "acr_reader_rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_aks == true && var.delegate_acr
  }
  group_object_id  = azuread_group.acr_reader["delegate_acr"].id
  member_object_id = azuread_group.rg_reader[each.key].id
}
