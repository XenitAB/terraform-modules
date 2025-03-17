apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-alloy
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: grafana-alloy
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://grafana.github.io/helm-charts
    targetRevision: 0.9.1
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
  sources:
    - repoURL: ${repo_url}
      targetRevision: HEAD
      path: platform/${tenant_name}/${cluster_id}/k8s-manifests/grafana-alloy