# AAD Group for Resource Group Owners
resource "azurecaf_name" "azuread_group_rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name          = each.value.common_name
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = local.resource_names.azuread_group_rg.prefixes
  suffixes      = concat(local.resource_names.azuread_group_rg.suffixes, ["owner"])
  use_slug      = false
}

resource "azuread_group" "rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = azurecaf_name.azuread_group_rg_owner[each.key].result
  prevent_duplicate_names = true
  security_enabled        = true
}

# AAD Group for Resource Group Contributors
resource "azurecaf_name" "azuread_group_rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name          = each.value.common_name
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = local.resource_names.azuread_group_rg.prefixes
  suffixes      = concat(local.resource_names.azuread_group_rg.suffixes, ["contributor"])
  use_slug      = false
}

resource "azuread_group" "rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = azurecaf_name.azuread_group_rg_contributor[each.key].result
  prevent_duplicate_names = true
  security_enabled        = true
}

# AAD Group for Resource Group Readers
resource "azurecaf_name" "azuread_group_rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name          = each.value.common_name
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = local.resource_names.azuread_group_rg.prefixes
  suffixes      = concat(local.resource_names.azuread_group_rg.suffixes, ["reader"])
  use_slug      = false
}

resource "azuread_group" "rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = azurecaf_name.azuread_group_rg_reader[each.key].result
  prevent_duplicate_names = true
  security_enabled        = true
}
