apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: kube-state-metrics
  namespace: grafana-agent
spec:
  interval: 1m0s
  url: "https://prometheus-community.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: kube-state-metrics
  namespace: grafana-agent
spec:
  chart:
    spec:
      chart: kube-state-metrics
      sourceRef:
        kind: HelmRepository
        name: kube-state-metrics
      version: v5.18.1
  interval: 1m0s
  values:
    priorityClassName: "platform-low"
    podSecurityPolicy:
      enabled: false
    metricLabelsAllowlist:
      - "namespaces=[xkf.xenit.io/kind]"
    namespaces: ${namespaces_csv}
    collectors:
      # Disable collection of configmaps and secrets to reduce amount of metrics
      #- configmaps
      #- secrets
      - certificatesigningrequests
      - cronjobs
      - daemonsets
      - deployments
      - endpoints
      - horizontalpodautoscalers
      - ingresses
      - jobs
      - limitranges
      - mutatingwebhookconfigurations
      - namespaces
      - networkpolicies
      - nodes
      - persistentvolumeclaims
      - persistentvolumes
      - poddisruptionbudgets
      - pods
      - replicasets
      - replicationcontrollers
      - resourcequotas
      - services
      - statefulsets
      - storageclasses
      - validatingwebhookconfigurations
      - volumeattachments
    prometheus:
      monitor:
        enabled: true
        honorLabels: true
        additionalLabels:
          xkf.xenit.io/monitoring: tenant