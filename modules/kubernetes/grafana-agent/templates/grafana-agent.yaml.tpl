apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-agent-operator
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: grafana-agent
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
    repoURL: https://grafana.github.io/helm-charts
    targetRevision: v0.3.21
    chart: grafana-agent-operator
    helm:
      valuesObject:
        resources:
          requests:
            cpu: 25m
            memory: 80Mi
          limits:
            memory: 256Mi
        kubeletService:
          namespace: grafana-agent
        serviceAccount:
          name: grafana-agent