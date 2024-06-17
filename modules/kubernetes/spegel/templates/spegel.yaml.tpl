apiVersion: v1
kind: Namespace
metadata:
 name: spegel
 labels:
   name: spegel
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: spegel
  namespace: spegel
spec:
  type: "oci"
  interval: 1m0s
  url: "oci://ghcr.io/spegel-org/helm-charts"
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
      version: v0.0.23
  interval: 1m0s
  values:
    resources:
      requests:
        cpu: 15m
        memory: 40Mi
      limits:
        memory: 140Mi
    spegel:
      mirrorResolveTimeout: "1s"
      registries:
        - https://cgr.dev
        - https://docker.io
        - https://ghcr.io
        - https://quay.io
        - https://mcr.microsoft.com
        - https://gcr.io
        - https://registry.k8s.io
        - https://k8s.gcr.io
        - https://lscr.io
        %{~ if private_registry != "" ~}
        - ${ private_registry }
        %{~ endif ~}
