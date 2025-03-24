apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: reloader
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "3"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: reloader
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
    repoURL: https://stakater.github.io/stakater-charts
    targetRevision: v0.0.102
    chart: reloader
    helm:
      valuesObject:
        deployment:
          priorityClassName: platform-low
          resources:
            requests:
              cpu: 15m
              memory: 50Mi