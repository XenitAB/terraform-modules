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
