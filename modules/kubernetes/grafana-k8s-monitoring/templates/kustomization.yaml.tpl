apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: grafana-k8s-monitoring
  namespace: flux-system
spec:
  dependsOn:
    - name: flux-system
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/grafana-k8s-monitoring/"
  prune: true

---

apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: grafana-k8s-monitoring-monitors
  namespace: flux-system
spec:
  dependsOn:
    - name: grafana-k8s-monitoring
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/monitors/"
  prune: true