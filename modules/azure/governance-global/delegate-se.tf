resource "azuread_group" "service_endpoint_join" {
  display_name            = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}serviceEndpointJoin"
  prevent_duplicate_names = true
}
