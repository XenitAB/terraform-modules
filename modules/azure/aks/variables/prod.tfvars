environmentShort = "prod"

aksConfiguration = {
  kubernetes_version = "1.16.9"
  sku_tier           = "Free"
  default_node_pool = {
    orchestrator_version = "1.16.9"
    vm_size              = "Standard_E2s_v3"
    min_count            = 1
    max_count            = 1
    node_labels          = {}
  },
  additional_node_pools = [
    {
      name                 = "normal"
      orchestrator_version = "1.16.9"
      vm_size              = "Standard_E4s_v3"
      min_count            = 2
      max_count            = 4
      node_taints          = []
      node_labels          = {}
    }
  ]
}
