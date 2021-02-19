# AAD Group for Subscription Owners
data "azuread_group" "sub_owner" {
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}owner"
}

# AAD Group for Subscription Contributors
data "azuread_group" "sub_contributor" {
  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}contributor"
}
