apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: starboard-exporter
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "2"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: trivy
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
    repoURL: https://giantswarm.github.io/giantswarm-catalog
    targetRevision: v0.8.0
    chart: starboard-exporter
    helm:
      valuesObject:
        global:
          podSecurityStandards:
            # Don't create a psp
            enforced: true
        monitoring:
          grafanaDashboard:
            # Don't create Grafana dashboard ConfigMap
            enabled: false
        networkpolicy:
          enabled: false