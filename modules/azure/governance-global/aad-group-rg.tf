# AAD Group for Resource Group Owners
resource "azuread_group" "rg_owner" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.common_name}${var.group_name_separator}owner"
  prevent_duplicate_names = false
  security_enabled        = true
}

# AAD Group for Resource Group Contributors
resource "azuread_group" "rg_contributor" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.common_name}${var.group_name_separator}contributor"
  prevent_duplicate_names = false
  security_enabled        = true
}


# AAD Group for Resource Group Readers
resource "azuread_group" "rg_reader" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  display_name            = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.common_name}${var.group_name_separator}reader"
  prevent_duplicate_names = false
  security_enabled        = true
}
