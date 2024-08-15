apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: grafana-agent
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/grafana-agent/"
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    namespace: grafana-agent
    name: grafana-agent-operator
  - apiVersion: apps/v1
    kind: StatefulSet
    namespace: grafana-agent
    name: grafana-agent
  - apiVersion: apps/v1
    kind: DaemonSet
    namespace: grafana-agent
    name: grafana-agent-logs
  - apiVersion: apps/v1
    kind: Deployment
    namespace: grafana-agent
    name: grafana-agent-traces
  - apiVersion: apps/v1
    kind: Deployment
    namespace: grafana-agent
    name: kube-state-metrics