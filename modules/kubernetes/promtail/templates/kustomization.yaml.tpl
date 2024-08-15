apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: promtail
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/promtail/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: DaemonSet
    namespace: promtail
    name: promtail
