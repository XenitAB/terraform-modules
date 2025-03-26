apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: datadog-operator
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: datadog
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
    repoURL: https://helm.datadoghq.com
    targetRevision: 1.0.2
    chart: datadog
    helm:
      valuesObject:
        apiKeyExistingSecret: datadog-operator-apikey
        appKeyExistingSecret: datadog-operator-appkey
        installCRDs: true
        image:
          tag: 1.0.2
        datadogMonitor:
          enabled: true
        resources:
          requests:
            cpu: 15m
            memory: 50Mi