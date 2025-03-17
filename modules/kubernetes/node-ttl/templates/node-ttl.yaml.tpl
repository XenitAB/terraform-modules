apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: node-ttl
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: node-ttl
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: oci://ghcr.io/xenitab/helm-charts
    targetRevision: v0.0.6
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
