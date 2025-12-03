apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: flux
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "0"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
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
    repoURL: https://fluxcd-community.github.io/helm-charts
    chart: flux2
    targetRevision: 2.16.4
    helm:
      values: |
        # Disable image automation components we don't use currently
        imageAutomationController:
          create: false
        imageReflectionController:
          create: false

        # Enable required controllers
        sourceController:
          priorityClassName: "platform-medium"
          create: true
          resources:
            requests:
              cpu: 50m
              memory: 128Mi
          serviceAccount:
            create: true
            automount: true
            annotations:
              azure.workload.identity/client-id: ${client_id}
          annotations:
            azure.workload.identity/client-id: ${client_id}
          labels:
            azure.workload.identity/use: "true"

        kustomizeController:
          priorityClassName: "platform-medium"
          create: true
          resources:
            requests:
              cpu: 50m
              memory: 128Mi
          serviceAccount:
            create: true
            automount: true
            annotations:
              azure.workload.identity/client-id: ${client_id}
          labels:
            azure.workload.identity/use: "true"

        helmController:
          priorityClassName: "platform-medium"
          create: true
          resources:
            requests:
              cpu: 50m
              memory: 128Mi
          serviceAccount:
            create: true
            automount: true
            annotations:
              azure.workload.identity/client-id: ${client_id}
          labels:
            azure.workload.identity/use: "true"

        notificationController:
          image: "ghcr.io/fluxcd/notification-controller"
          tag: "v1.7.3"
          priorityClassName: "platform-medium"
          create: true
          resources:
            requests:
              cpu: 50m
              memory: 128Mi
          serviceAccount:
            create: true
            automount: true
            annotations:
              azure.workload.identity/client-id: ${client_id}
          labels:
            azure.workload.identity/use: "true"
          container:
            additionalArgs: [
              --feature-gates=ObjectLevelWorkloadIdentity=true]


        # Global log level (matches chart key)
        logLevel: info

        # Optional: add a PodMonitor via values if needed later (kept off by default)
        prometheus:
          podMonitor:
            create: false

        # Leave tolerations blank (chart expects an array)
        tolerations: []
