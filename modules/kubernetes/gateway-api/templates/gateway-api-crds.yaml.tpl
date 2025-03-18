apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gateway-api-crds
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  sources:
    - repoURL: https://github.com/kubernetes-sigs/gateway-api
      targetRevision: HEAD
      path: config/crd/${api_channel}
      ref: ${api_version}