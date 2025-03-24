apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gateway-api-crds
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
spec:
  project: ${project}
  destination:
    server: ${server}
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: false
      selfHeal: true
    syncOptions:
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  sources:
    - repoURL: https://github.com/kubernetes-sigs/gateway-api
      targetRevision: HEAD
      path: config/crd/${api_channel}
      ref: ${api_version}