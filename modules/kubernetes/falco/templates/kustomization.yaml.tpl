apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: falco
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/falco/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: DaemonSet
    namespace: falco
    name: falco
  - apiVersion: apps/v1
    kind: DaemonSet
    namespace: falco
    name: falco-exporter
