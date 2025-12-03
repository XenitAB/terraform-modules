apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: falco-exporter
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: falco
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
    repoURL: https://falcosecurity.github.io/charts
    targetRevision: 0.12.2
    chart: falco-exporter
    helm:
      valuesObject:
        image:
          tag: "0.8.7"
        priorityClassName: platform-high
