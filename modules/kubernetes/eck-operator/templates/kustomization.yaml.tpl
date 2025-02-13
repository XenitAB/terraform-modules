apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: eck-operator
  namespace: flux-system
spec:
  dependsOn:
    - name: flux-system
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/eck-operator/"
  prune: true
