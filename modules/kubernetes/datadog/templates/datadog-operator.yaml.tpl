apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: datadog-operator
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
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
    targetRevision: 2.15.0
    chart: datadog-operator
    helm:
      valuesObject:
        site: datadoghq.eu
        apiKeyExistingSecret: datadog-operator-apikey
        appKeyExistingSecret: datadog-operator-appkey
        installCRDs: true
        datadogMonitor:
          enabled: true
        resources:
          requests:
            cpu: 15m
            memory: 50Mi
