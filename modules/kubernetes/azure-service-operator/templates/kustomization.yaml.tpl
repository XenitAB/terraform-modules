apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: azure-service-operator
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/azure-service-operator/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: azureserviceoperator-system
    name: azureserviceoperator-controller-manager