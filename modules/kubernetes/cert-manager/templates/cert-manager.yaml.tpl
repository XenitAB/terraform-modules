apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cert-manager
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: cert-manager
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://charts.jetstack.io
    targetRevision: v1.16.3
    chart: cert-manager
    helm:
      valuesObject:
        installCRDs: false
        global:
          priorityClassName: "platform-medium"
        %{~ if gateway_api_enabled ~}
        config:
          apiVersion: controller.config.cert-manager.io/v1alpha1
          kind: ControllerConfiguration
          enableGatewayAPI: true
        %{~ endif ~}
        podLabels:
          azure.workload.identity/use: "true"
        serviceAccount:
          annotations:
            azure.workload.identity/client-id: ${client_id}
        tolerations:
          - key: "kubernetes.azure.com/scalesetpriority"
            operator: "Equal"
            value: "spot"
            effect: "NoSchedule"
        webhook:
          resources:
            requests:
              cpu: 30m
              memory: 100Mi
        cainjector:
          resources:
            requests:
              cpu: 25m
              memory: 250Mi
        dns01RecursiveNameserversOnly: true
        dns01RecursiveNameservers: "8.8.8.8:53,1.1.1.1:53"