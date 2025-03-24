apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: falco-exporter
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "1"
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
    targetRevision: v0.12.1
    chart: falco-exporter
    helm:
      valuesObject:
        priorityClassName: platform-high
