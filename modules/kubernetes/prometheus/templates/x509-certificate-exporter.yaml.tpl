apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: x509-certificate-exporter
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: prometheus
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://charts.enix.io
    targetRevision: 3.8.0
    chart: x509-certificate-exporter
    helm:
      valuesObject:
        secretsExporter:
          includeNamespaces:
            - prometheus
        priorityClassName: platform-medium
        prometheusRules:
          # We don't manage prometheus rules per cluster.
          create: false
        prometheusServiceMonitor:
          # We use serviceMonitors from another helm chart.
          create: false
