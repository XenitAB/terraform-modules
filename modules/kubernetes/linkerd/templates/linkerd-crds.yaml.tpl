apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: linkerd-crds
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: linkerd
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=false
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - ServerSideApply=true
  source:
    repoURL: https://helm.linkerd.io/stable
    targetRevision: 1.8.0
    chart: linkerd-crds