apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: vector
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "1"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: control-plane-logs
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
  ignoreDifferences:
  - group: apps
    kind: Deployment
    name: vector
    jqPathExpressions:
    - .spec.minReadySeconds
    - .spec.template.spec.containers[0].ports
    - .spec.template.spec.securityContext
  source:
    repoURL: https://helm.vector.dev
    targetRevision: v0.40.0
    chart: vector
    helm:
      valuesObject:
        role: "Stateless-Aggregator"
        podAnnotations:
          secret.reloader.stakater.com/reload: "vector"
        podLabels:
          azure.workload.identity/use: "true"
        args:
          - "--config-dir=/config"
        existingConfigMaps:
          - vector
        dataDir: "/vector-data-dir"
        containerPorts: []
        env:
          - name: HOST
            valueFrom:
              configMapKeyRef:
                name: "vector"
                key: hostname
          - name: TOPIC
            valueFrom:
              configMapKeyRef:
                name: "vector"
                key: topic
          - name: PASSWORD
            valueFrom:
              secretKeyRef:
                name: "msg-queue"
                key: connectionstring
        extraVolumeMounts:
          - name: secret
            readOnly: true
            mountPath: "/config"
          - name: secret-store
            mountPath: "/mnt/secrets-store"
            readOnly: true
        extraVolumes:
          - name: secret
            configMap:
              name: "vector"
          - name: secret-store
            csi:
              driver: secrets-store.csi.k8s.io
              readOnly: true
              volumeAttributes:
                secretProviderClass: vector
        podSecurityContext:
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 1000
          capabilities:
            drop:
              - ALL
        service:
          enabled: false
        serviceAccount:
          create: true
          name: vector
          automountToken: false
          annotations:
            azure.workload.identity/client-id: ${client_id}