apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: gatekeeper
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/gatekeeper/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: gatekeeper-system
    name: gatekeeper-audit
  - apiVersion: apps/v1
    kind: Deployment
    namespace: gatekeeper-system
    name: gatekeeper-controller-manager
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: gatekeeper-template
  namespace: flux-system
spec:
  dependsOn:
    - name: gatekeeper
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/gatekeeper-template/"
  prune: true
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: gatekeeper-config
  namespace: flux-system
spec:
  dependsOn:
    - name: gatekeeper
    - name: gatekeeper-template
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/gatekeeper-config/"
  prune: true
