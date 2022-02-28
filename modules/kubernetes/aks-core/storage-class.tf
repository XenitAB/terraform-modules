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
