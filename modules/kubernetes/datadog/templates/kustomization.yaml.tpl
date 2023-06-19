apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: datadog-operator
  namespace: flux-system
spec:
  dependsOn:
    - name: gatekeeper-config
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/datadog-operator/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: datadog
    name: datadog-operator
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: datadog
  namespace: flux-system
spec:
  dependsOn:
    - name: gatekeeper-config
    - name: datadog-operator
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/datadog/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: datadog
    name: datadog-cluster-agent
  - apiVersion: apps/v1
    kind: DaemonSet
    namespace: datadog
    name: datadog-agent
