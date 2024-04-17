apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: starboard-exporter
  namespace: trivy
spec:
  interval: 1m0s
  url: "https://giantswarm.github.io/giantswarm-catalog/"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: starboard-exporter
  namespace: trivy
spec:
  chart:
    spec:
      chart: starboard-exporter
      sourceRef:
        kind: HelmRepository
        name: starboard-exporter
      version: v0.7.8
  interval: 1m0s
  values:
    networkpolicy:
      enabled: false