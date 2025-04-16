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
      version: v0.8.1
  interval: 1m0s
  values:
    global:
      podSecurityStandards:
        # Don't create a psp
        enforced: true
    monitoring:
      grafanaDashboard:
        # Don't create Grafana dashboard ConfigMap
        enabled: false
    networkpolicy:
      enabled: false