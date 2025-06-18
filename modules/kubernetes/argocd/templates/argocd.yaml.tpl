apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argocd
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "0"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: argocd
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
  source:
    repoURL: ghcr.io/argoproj/argo-helm
    targetRevision: 8.0.6
    chart: argo-cd
    helm:
      valuesObject:
        ${values}