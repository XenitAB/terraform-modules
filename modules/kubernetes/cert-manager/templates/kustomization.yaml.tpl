apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: cert-manager
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/cert-manager/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: cert-manager
    name: cert-manager