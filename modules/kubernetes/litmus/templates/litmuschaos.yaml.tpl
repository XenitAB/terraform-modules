apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: litmuschaos
  namespace: litmus
spec:
  interval: 1m0s
  url: "https://litmuschaos.github.io/litmus-helm/"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: litmuschaos
  namespace: litmus
spec:
  chart:
    spec:
      chart: litmus
      sourceRef:
        kind: HelmRepository
        name: litmuschaos
      version: 3.12.0
  interval: 1m0s
  values:
    #portal:
    #  server:
    #    waitForMongodb:
    #      securityContext:
    #        runAsNonRoot: true
    #        readOnlyRootFilesystem: true