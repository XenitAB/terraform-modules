resource "azuread_group" "aadGroupView" {
  for_each = { for ns in var.k8sNamespaces : ns.name => ns }
  name     = "${local.aksGroupNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.value.name}${local.groupNameSeparator}view"
}

resource "azuread_group" "aadGroupEdit" {
  for_each = { for ns in var.k8sNamespaces : ns.name => ns }
  name     = "${local.aksGroupNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.value.name}${local.groupNameSeparator}edit"
}

resource "azuread_group" "aadGroupClusterAdmin" {
  name = "${local.aksGroupNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}clusteradmin"
}

resource "azuread_group" "aadGroupClusterView" {
  name = "${local.aksGroupNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}clusterview"
}
