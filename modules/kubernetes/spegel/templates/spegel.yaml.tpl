apiVersion: v1
kind: Namespace
metadata:
 name: spegel
 labels:
   name              = "spegel"
   xkf.xenit.io/kind = "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: spegel
  namespace: spegel
spec:
  type: "oci"
  interval: 1m0s
  url: "oci://ghcr.io/xenitab/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: spegel
  namespace: spegel
spec:
  chart:
    spec:
      chart: spegel
      sourceRef:
        kind: HelmRepository
        name: spegel
      version: v0.0.7
  interval: 1m0s
  values:
    resources:
      requests:
        cpu: 15m
        memory: 40Mi
      limits:
        memory: 140Mi
