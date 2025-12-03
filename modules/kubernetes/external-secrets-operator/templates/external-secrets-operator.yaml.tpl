apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: external-secrets-operator
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "0"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: external-secrets-operator
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://charts.external-secrets.io
    targetRevision: 0.17.0
    chart: external-secrets
    helm:
      valuesObject:
        certController:
          log:
            level: ${config.log_level}
          metrics:
            service:
              enabled: ${config.metrics_enabled}
          podDisruptionBudget:
            enabled: ${config.pdb_enabled}
          priorityClassName: "platform-medium"
          replicaCount: ${config.replica_count}
          revisionHistoryLimit: 5
        global:
          affinity:
          tolerations:
            - key: "kubernetes.azure.com/scalesetpriority"
              operator: "Equal"
              value: "spot"
              effect: "NoSchedule"
        leaderElect: true
        metrics:
          service:
            enabled: ${config.metrics_enabled}
        podDisruptionBudget:
          enabled: ${config.pdb_enabled}
        priorityClassName: "platform-medium"
        replicaCount: ${config.replica_count}
        revisionHistoryLimit: 5
        serviceMonitor:
          enabled: ${config.service_monitor_enabled}
        webhook:
          log:
            level: ${config.log_level}
          metrics:
            service:
              enabled: ${config.metrics_enabled}
          podDisruptionBudget:
            enabled: ${config.pdb_enabled}
          replicaCount: ${config.replica_count}
          revisionHistoryLimit: 5