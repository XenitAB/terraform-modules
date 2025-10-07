apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: external-dns
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
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
    repoURL: https://kubernetes-sigs.github.io/external-dns/
    targetRevision: 1.19.0
    chart: external-dns
    helm:
      valuesObject:
        provider:
          name: azure
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
          labels:
            azure.workload.identity/use: "true"
          annotations:
            azure.workload.identity/client-id: ${client_id}
        podLabels: 
          azure.workload.identity/use: "true"

        extraVolumes:
          - name: azure-config-file
            secret:
              secretName: external-dns-azure
        extraVolumeMounts:
          - name: azure-config-file
            mountPath: /etc/kubernetes
            readOnly: true
            
        policy: sync # will also delete the record
        registry: "txt"
        txtOwnerId: "${txt_owner_id}"
        priorityClassName: "platform-low"
        resources:
          requests:
            cpu: 15m
            memory: 78Mi