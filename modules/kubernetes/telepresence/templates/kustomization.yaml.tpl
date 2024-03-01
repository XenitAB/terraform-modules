apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: telepresence
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/telepresence/"
  prune: true
  wait: true
  healthChecks:
  - apiVersion: apps/v1
    kind: deployment
    namespace: telepresence
    name: telepresence-telepresence
