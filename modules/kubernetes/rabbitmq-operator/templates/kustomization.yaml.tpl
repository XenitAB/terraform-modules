apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: rabbitmq-operator
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/rabbitmq-operator/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: rabbitmq-system
    name: rabbitmq-operator-rabbitmq-cluster-operator