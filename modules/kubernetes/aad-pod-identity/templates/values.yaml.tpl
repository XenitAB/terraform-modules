forceNameSpaced: true
nmi:
  allowNetworkPluginKubenet: true

azureIdentities:
%{ for namespace in namespaces ~}
  - name: "${namespace.name}"
    namespace: "${namespace.name}"
    type: "0"
    resourceID: "${aad_pod_identity[namespace.name].id}"
    clientID: "${aad_pod_identity[namespace.name].client_id}"
    binding:
      name: "${namespace.name}"
      selector: "${namespace.name}"
%{ endfor }
