resource "kubernetes_storage_class" "zrs_standard" {
  metadata {
    name = "managed-csi-zrs"
  }

  storage_provisioner = "disk.csi.azure.com"
  reclaim_policy      = "Delete"

  parameters = {
    skuName = "StandardSSD_ZRS"
  }

  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "zrs_premium" {
  metadata {
    name = "managed-csi-premium-zrs"
  }

  storage_provisioner = "disk.csi.azure.com"
  reclaim_policy      = "Delete"

  parameters = {
    skuName = "Premium_ZRS"
  }

  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "azurefile_zrs_standard" {
  metadata {
    name = "managed-azurefile-csi-zrs"
  }

  storage_provisioner = "file.csi.azure.com"
  reclaim_policy      = "Delete"

  parameters = {
    skuName = "StandardSSD_ZRS"
  }

  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "azurefile_zrs_premium" {
  metadata {
    name = "managed-azurefile-csi-premium-zrs"
  }

  storage_provisioner = "file.csi.azure.com"
  reclaim_policy      = "Delete"

  parameters = {
    skuName = "Premium_ZRS"
  }

  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "additional" {
  for_each = { for class in var.additional_storage_classes : class.name => class }

  metadata {
    name = each.key
  }

  storage_provisioner = each.value.provisioner
  reclaim_policy      = each.value.reclaim_policy

  parameters = {
    skuName = each.value.sku_name
  }

  volume_binding_mode = each.value.binding_mode
}
