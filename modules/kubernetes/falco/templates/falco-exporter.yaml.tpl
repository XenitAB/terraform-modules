apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: falco_exporter
  namespace: falco_exporter
spec:
  type: "oci"
  interval: 1m0s
  url: "https://falcosecurity.github.io/charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: falco_exporter
  namespace: falco
spec:
  chart:
    spec:
      chart: falco_exporter
      sourceRef:
        kind: HelmRepository
        name: falco_exporter
      version: v0.9.1
  interval: 1m0s
  values:
    priorityClassName: platform-high

    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
      - operator: Exists
