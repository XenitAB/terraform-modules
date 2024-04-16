apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: trivy
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
    pod:
      user:
        id: 1000
      group:
        id: 1000

    resources:
      requests:
        cpu: 100m
        memory: 220Mi
      limits:
        cpu: 100m
        memory: 220Mi

    monitoring:
      serviceMonitor:
        enabled: true

      grafanaDashboard:
        enabled: true

    psp:
      enabled: false

    networkpolicy:
      enabled: false