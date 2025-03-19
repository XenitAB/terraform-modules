apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: linkerd-viz
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: linkerd-viz
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=false
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://helm.linkerd.io/stable
    targetRevision: 30.3.4
    chart: linkerd-viz
    helm:
      valuesObject:
        installNamespace: false
        defaultRegistry: ghcr.io/linkerd
