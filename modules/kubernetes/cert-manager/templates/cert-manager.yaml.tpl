apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cert-manager
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "0"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: cert-manager
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
  ignoreDifferences:
  - group: admissionregistration.k8s.io
    kind: ValidatingWebhookConfiguration
    name: cert-manager-webhook
    jqPathExpressions:
    - .webhooks[].namespaceSelector.matchExpressions[] | select(.key == "control-plane")
    - .webhooks[].namespaceSelector.matchExpressions[] | select(.key == "kubernetes.azure.com/managedby")
  source:
    repoURL: https://charts.jetstack.io
    targetRevision: v1.19.1
    chart: cert-manager
    helm:
      valuesObject:
        installCRDs: true
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