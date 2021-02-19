resource "azuread_group" "acr_push" {
  display_name            = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpush"
  prevent_duplicate_names = true
}

resource "azuread_group" "acr_pull" {
  display_name            = "${var.aks_group_name_prefix}${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}acrpull"
  prevent_duplicate_names = true
}
