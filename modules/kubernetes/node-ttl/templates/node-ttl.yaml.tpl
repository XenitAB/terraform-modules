apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: node-ttl
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "3"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: node-ttl
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
    repoURL: ghcr.io/xenitab/helm-charts
    targetRevision: v0.0.10
    chart: node-ttl
    helm:
      valuesObject:
        resources:
          requests:
            cpu: 5m
            memory: 20Mi
          limits:
            memory: 50Mi
        nodeTtl:
          statusConfigMapNamespace: ${status_config_map_namespace}
