apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: trivy
  namespace: argocd
  annotations:
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
    - Replace=true
  source:
    repoURL: https://aquasecurity.github.io/helm-charts/
    targetRevision: v0.11.0
    chart: trivy
    helm:
      valuesObject:
        trivy:
          labels:
            azure.workload.identity/use: "true"
          serviceAccount:
            annotations:
              azure.workload.identity/client-id: ${client_id}
        persistence:
          storageClass: ${volume_claim_storage_class_name}
