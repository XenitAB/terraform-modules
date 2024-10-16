apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: contour
  namespace: projectcontour
spec:
  interval: 1m0s
  url: "bitnami https://charts.bitnami.com/bitnami"
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: contour
  namespace: projectcontour
spec:
  chart:
    spec:
      chart: contour
      sourceRef:
        kind: HelmRepository
        name: contour
      version: 19.2.0
  interval: 1m0s
  values: