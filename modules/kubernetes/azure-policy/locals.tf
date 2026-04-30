locals {
  system_namespaces_list = ["calico-system", "gatekeeper-system", "kube-system", "tigera-operator"]
  system_namespaces      = join(", ", [for ns in local.system_namespaces_list : "'${ns}'"])

  # Per-template extra namespace exclusions beyond system_namespaces_list.
  # These are combined with var.azure_policy_config.exclude_namespaces at render time.
  mutation_extra_exclude_namespaces = {
    "container-disallow-privilege-escalation.yaml.tpl"           = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa", "node-sysctls"]
    "container-drop-capabilities.yaml.tpl"                       = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa", "trivy"]
    "container-read-only-root-fs.yaml.tpl"                       = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa"]
    "ephemeral-container-disallow-privilege-escalation.yaml.tpl" = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa", "node-sysctls"]
    "ephemeral-container-drop-capabilities.yaml.tpl"             = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa", "trivy"]
    "ephemeral-container-read-only-root-fs.yaml.tpl"             = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa"]
    "init-container-disallow-privilege-escalation.yaml.tpl"      = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa", "node-sysctls"]
    "init-container-drop-capabilities.yaml.tpl"                  = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa", "trivy"]
    "init-container-read-only-root-fs.yaml.tpl"                  = ["aad-pod-identity", "cert-manager", "csi-secrets-store-provider-azure", "datadog", "external-dns", "falco", "ingress-nginx", "prometheus", "reloader", "spegel", "vpa"]
  }

  azure_identity_format = base64encode(
    templatefile("${path.module}/templates/azure-identity-format.yaml.tpl", {
    })
  )

  azure_remove_node_spot_taints = base64encode(
    templatefile("${path.module}/templates/azure-remove-node-spot-taints.yaml.tpl", {
    })
  )

  flux_disable_cross_namespace_source = base64encode(
    templatefile("${path.module}/templates/flux-disable-cross-namespace-source.yaml.tpl", {
    })
  )

  flux_require_service_account = base64encode(
    templatefile("${path.module}/templates/flux-require-service-account.yaml.tpl", {
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
