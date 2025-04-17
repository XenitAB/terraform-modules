apiVersion: v1
kind: Namespace
metadata:
 name: node-ttl
 labels:
   name: node-ttl
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: node-ttl
  namespace: node-ttl
spec:
  type: "oci"
  interval: 1m0s
  url: "oci://ghcr.io/xenitab/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: node-ttl
  namespace: node-ttl
spec:
  chart:
    spec:
      chart: node-ttl
      sourceRef:
        kind: HelmRepository
        name: node-ttl
      version: v0.0.7
  interval: 1m0s
  values:
    resources:
      requests:
        cpu: 5m
        memory: 20Mi
      limits:
        memory: 50Mi
    nodeTtl:
      statusConfigMapNamespace: ${status_config_map_namespace}
