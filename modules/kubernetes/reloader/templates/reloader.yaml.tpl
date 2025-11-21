apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: reloader
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
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
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://stakater.github.io/stakater-charts
    targetRevision: 2.2.3
    chart: reloader
    helm:
      valuesObject:
        deployment:
          priorityClassName: platform-low
          resources:
            requests:
              cpu: 15m
              memory: 50Mi
