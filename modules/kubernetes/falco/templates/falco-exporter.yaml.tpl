apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: falco-exporter
  namespace: falco
spec:
  interval: 1m0s
  url: "https://falcosecurity.github.io/charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: falco-exporter
  namespace: falco
spec:
  chart:
    spec:
      chart: falco-exporter
      sourceRef:
        kind: HelmRepository
        name: falco-exporter
      version: v0.12.1
  interval: 1m0s
  values:
    priorityClassName: platform-high
