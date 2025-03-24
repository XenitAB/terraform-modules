apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cert-manager-crds
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: cert-manager
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: false
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - ServerSideApply=true
  source:
    repoURL: https://charts.jetstack.io
    targetRevision: v1.16.3
    chart: cert-manager
    helm:
      valuesObject:
        installCRDs: true