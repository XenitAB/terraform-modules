apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-alloy
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "2"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: grafana-alloy
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
    repoURL: https://grafana.github.io/helm-charts
    targetRevision: 10.1.5
    chart: alloy
    helm:
      valuesObject:
        serviceAccount:
          create: true
          annotations:
            azure.workload.identity/client-id: ${client_id}
        alloy:
          extraPorts:
            - name: otpl-http-trace
              port: 4318
              targetPort: 4318
              protocol: TCP
          mounts:
            extra:
              - mountPath: /tmp/alloy
                name: temp-storage
              - name: secret-store
                mountPath: "/mnt/secrets-store"
                readOnly: true
          securityContext:
            runAsUser: 473
            runAsGroup: 473
          configMap:
            create: false
            name: grafana-alloy-config
            key: config
        controller:
          podLabels:
            azure.workload.identity/use: "true"
          type: 'deployment'
          volumes:
            extra:
            - name: temp-storage
            - name: secret-store
              csi:
                driver: secrets-store.csi.k8s.io
                readOnly: true
                volumeAttributes:
                  secretProviderClass: grafana-alloy-secrets