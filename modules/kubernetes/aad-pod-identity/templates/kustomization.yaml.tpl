apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: aad-pod-identity
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/aad-pod-identity/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: DaemonSet
    namespace: aad-pod-identity
    name: aad-pod-identity-nmi
  - apiVersion: apps/v1
    kind: Deployment
    namespace: aad-pod-identity
    name: aad-pod-identity-mic
