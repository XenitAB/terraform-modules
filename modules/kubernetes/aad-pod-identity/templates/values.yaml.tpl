forceNameSpaced: true

mic:
  prometheusPort: 8888
  priorityClassName: "platform-medium"

nmi:
  allowNetworkPluginKubenet: true
  prometheusPort: 9090
  priorityClassName: "platform-high"

  tolerations:
  - operator: "Exists"

azureIdentities:
%{ for namespace in namespaces ~}
  "${namespace.name}":
    namespace: "${namespace.name}"
    type: "0"
    resourceID: "${aad_pod_identity[namespace.name].id}"
    clientID: "${aad_pod_identity[namespace.name].client_id}"
    binding:
      name: "${namespace.name}"
      selector: "${namespace.name}"
%{ endfor }

