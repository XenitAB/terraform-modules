apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: litmus
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/litmus/"
  prune: true
  wait: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: litmus
    name: litmus-auth-server
  - apiVersion: apps/v1
    kind: Deployment
    namespace: litmus
    name: litmus-frontend
  - apiVersion: apps/v1
    kind: Deployment
    namespace: litmus
    name: litmus-server