apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: envoy-gateway-crds
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "-1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
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
    - ServerSideApply=true
  source:
    repoURL: docker.io/envoyproxy
    targetRevision: ${envoy_gateway_config.chart_version}
    chart: gateway-crds-helm
    helm:
      valuesObject:
        crds:
          envoyGateway:
            enabled: true
          gatewayAPI:
            enabled: false
