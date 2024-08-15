apiVersion: v1
kind: Namespace
metadata:
 name: reloader
 labels:
   name: reloader
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: reloader
  namespace: reloader
spec:
  interval: 1m0s
  url: "https://stakater.github.io/stakater-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: reloader
  namespace: reloader
spec:
  chart:
    spec:
      chart: reloader
      sourceRef:
        kind: HelmRepository
        name: reloader
      version: v0.0.102
  interval: 1m0s
  values:
    deployment:
      priorityClassName: platform-low
      resources:
        requests:
          cpu: 15m
          memory: 50Mi
