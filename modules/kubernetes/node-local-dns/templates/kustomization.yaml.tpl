apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: node-local-dns
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/node-local-dns/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: DaemonSet
    namespace: kube-system
    name: node-local-dns
