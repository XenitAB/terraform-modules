locals {
  system_namespaces = "'calico-system', 'gatekeeper-system', 'kube-system', 'tigera-operator'"

  azure_identity_format = base64encode(
    templatefile("${path.module}/templates/azure-identity-format.yaml.tpl", {
    })
  )

  azure_remove_node_spot_taints = base64encode(
    templatefile("${path.module}/templates/azure-remove-node-spot-taints.yaml.tpl", {
    })
  )

  k8s_block_node_port = base64encode(
    templatefile("${path.module}/templates/k8s-block-node-port.yaml.tpl", {
    })
  )

  k8s_pod_priority_class = base64encode(
    templatefile("${path.module}/templates/k8s-pod-priority-class.yaml.tpl", {
    })
  )

  k8s_require_ingress_class = base64encode(
    templatefile("${path.module}/templates/k8s-require-ingress-class.yaml.tpl", {
    })
  )

  k8s_secrets_store_csi_unique_volume = base64encode(
    templatefile("${path.module}/templates/k8s-secrets-store-csi-unique-volume.yaml.tpl", {
    })
  )
}