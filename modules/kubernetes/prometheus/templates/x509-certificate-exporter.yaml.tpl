apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: x509-certificate-exporter
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "2"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: prometheus
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
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
