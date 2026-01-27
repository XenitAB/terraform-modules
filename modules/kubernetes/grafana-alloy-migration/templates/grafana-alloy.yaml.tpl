apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-alloy
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "1"
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
    targetRevision: 1.5.2
    chart: alloy
    helm:
      valuesObject:
        serviceAccount:
          create: true
          name: grafana-alloy
          annotations:
            azure.workload.identity/client-id: ${client_id}
        alloy:
          extraPorts:
            - name: otlp-http
              port: 4318
              targetPort: 4318
              protocol: TCP
            - name: otlp-grpc
              port: 4317
              targetPort: 4317
              protocol: TCP
            - name: otlp-legacy
              port: 55681
              targetPort: 55681
              protocol: TCP
            - name: jaeger
              port: 55678
              targetPort: 55678
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
            key: config.alloy
          resources:
            requests:
              cpu: 25m
              memory: 100Mi
        controller:
          podLabels:
            azure.workload.identity/use: "true"
          type: 'deployment'
          replicas: 2
          priorityClassName: platform-medium
          tolerations:
            - operator: "Exists"
          volumes:
            extra:
            - name: temp-storage
              emptyDir: {}
            - name: secret-store
              csi:
                driver: secrets-store.csi.k8s.io
                readOnly: true
                volumeAttributes:
                  secretProviderClass: grafana-alloy-credentials
