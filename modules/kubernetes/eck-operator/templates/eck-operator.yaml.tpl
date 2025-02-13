apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: elastic
  namespace: eck-system
spec:
  interval: 1m0s
  url: "https://helm.elastic.co"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: eck-operator
  namespace: eck-system
spec:
  interval: 1m0s
  chart:
    spec:
      chart: eck-operator
      sourceRef:
        kind: HelmRepository
        name: elastic
      version: 2.16.1

  values:
    managedNamespaces:
      %{ for ns in eck_managed_namespaces ~}
    - ${ns}
      %{ endfor }
