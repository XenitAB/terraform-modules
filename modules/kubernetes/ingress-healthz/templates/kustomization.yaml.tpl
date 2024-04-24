apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: ingress-healthz
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/ingress-healthz/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: ingress-healthz
    name: ingress-healthz-nginx
