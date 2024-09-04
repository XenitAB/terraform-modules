apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: grafana-k8s-monitoring
  namespace: flux-system
spec:
  dependsOn:
    - name: gatekeeper-config
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/grafana-k8s-monitoring/"
  prune: true
