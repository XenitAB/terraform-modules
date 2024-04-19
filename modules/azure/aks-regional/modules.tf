module "velero" {
  for_each = {
    for s in ["velero"] :
    s => s
    if var.velero_enabled
  }

  source = "./velero/"

  aks_managed_identity = var.aks_managed_identity
  location_short       = var.location_short
  name                 = var.name
  environment          = var.environment
  unique_suffix        = var.unique_suffix
}