apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: trivy
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/trivy/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: trivy
    name: starboard-exporter
  - apiVersion: apps/v1
    kind: StatefulSet
    namespace: trivy
    name: trivy
  - apiVersion: apps/v1
    kind: Deployment
    namespace: trivy
    name: trivy-operator