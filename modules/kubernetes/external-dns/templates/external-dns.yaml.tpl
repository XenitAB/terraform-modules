apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: external-dns
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "0"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: external-dns
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
    repoURL: registry-1.docker.io/bitnamicharts
    targetRevision: 8.7.3
    chart: external-dns
    helm:
      valuesObject:
        provider: "azure"
        sources:
          %{~ for item in sources ~}
          - "${item}"
          %{~ endfor ~}
        %{~ if length(extra_args) > 0 ~}
        extraArgs:
          %{~ for arg in extra_args ~}
          - "${arg}"
          %{~ endfor ~}
        %{~ endif ~}
        logFormat: json
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
        serviceAccount:
          annotations:
            azure.workload.identity/client-id: ${client_id}
        podLabels: 
          azure.workload.identity/use: "true"
        azure:
          useWorkloadIdentityExtension: true
          tenantId: "${tenant_id}"
          subscriptionId: "${subscription_id}"
          resourceGroup: "${resource_group_name}"
        policy: sync # will also delete the record
        registry: "txt"
        txtOwnerId: "${txt_owner_id}"
        priorityClassName: "platform-low"
        resources:
          requests:
            cpu: 15m
            memory: 78Mi