apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: starboard-exporter
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: trivy
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
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