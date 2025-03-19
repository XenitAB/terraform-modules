apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: controle-plane-logs
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: controle-plane-logs
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
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
  sources:
    - repoURL: ${repo_url}
      targetRevision: HEAD
      path: platform/${tenant_name}/${cluster_id}/k8s-manifests/control-plane-logs