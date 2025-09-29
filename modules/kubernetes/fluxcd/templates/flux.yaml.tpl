apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: flux
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "0"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: flux-system
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
    repoURL: oci://ghcr.io/fluxcd/charts/flux2
    chart: flux2
    targetRevision: ${flux_chart_version}
    helm:
      values: |
        imageAutomationController:
          create: false
        imageReflectorController:
          create: false
        notificationController:
          create: true
        helmController:
          create: true
        kustomizeController:
          create: true
        sourceController:
          create: true
        multitenancy:
          enabled: true
          managedTenants:
            enabled: true
        resources:
          requests:
            cpu: 50m
            memory: 128Mi
        serviceAccounts:
          sourceController:
            create: true
            annotations:
              azure.workload.identity/client-id: ${client_id}
          kustomizeController:
            create: true
            annotations:
              azure.workload.identity/client-id: ${client_id}
          helmController:
            create: true
            annotations:
              azure.workload.identity/client-id: ${client_id}
          notificationController:
            create: true
            annotations:
              azure.workload.identity/client-id: ${client_id}
        podLabels:
          azure.workload.identity/use: "true"
        tolerations: []
