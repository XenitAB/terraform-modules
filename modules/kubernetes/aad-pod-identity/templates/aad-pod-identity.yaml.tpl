apiVersion: v1
kind: Namespace
metadata:
 name: aad-pod-identity
 labels:
   name: aad-pod-identity
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: aad-pod-identity
  namespace: aad-pod-identity
spec:
  interval: 1m0s
  url: "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: aad-pod-identity
  namespace: aad-pod-identity
spec:
  chart:
    spec:
      chart: aad-pod-identity
      sourceRef:
        kind: HelmRepository
        name: aad-pod-identity
      version: 4.1.16
  interval: 1m0s
  values:
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