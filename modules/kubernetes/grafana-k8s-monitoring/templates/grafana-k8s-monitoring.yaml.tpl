apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: grafana-k8s-monitoring
  namespace: grafana-k8s-monitoring
spec:
  interval: 1m0s
  url: "https://grafana.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: grafana-k8s-monitoring
  namespace: grafana-k8s-monitoring
spec:
  interval: 1m0s
  chart:
    spec:
      chart: k8s-monitoring
      sourceRef:
        kind: HelmRepository
        name: grafana-k8s-monitoring
      version: 1.4.8
  values:
    alloy:
      alloy:
        resources:
          requests:
            cpu: "1m"
            memory: "500Mi"

        storagePath: /var/lib/alloy
        mounts:
          extra:
            - name: alloy-wal
              mountPath: /var/lib/alloy
      controller:
        autoscaling:
          enabled: true
          minReplicas: 2
          maxReplicas: 20
          targetCPUUtilizationPercentage: 0
          targetMemoryUtilizationPercentage: 80

        enableStatefulSetAutoDeletePVC: true
        volumeClaimTemplates:
          - metadata:
              name: alloy-wal
            spec:
              accessModes: ["ReadWriteOnce"]
              storageClassName: "default"
              resources:
                requests:
                  storage: 5Gi
    alloy-logs:
      alloy:
        storagePath: /var/lib/alloy
        mounts:
          extra:
            - name: alloy-log-positions
              mountPath: /var/lib/alloy
            - name: secret-store
              mountPath: "/mnt/secrets-store"
              readOnly: true
      controller:
        volumes:
          extra:
            - name: alloy-log-positions
              hostPath:
                path: /var/alloy-log-storage
                type: DirectoryOrCreate
            - name: secret-store
              csi:
                driver: secrets-store.csi.k8s.io
                readOnly: true
                volumeAttributes:
                  secretProviderClass: grafana-k8s-monitor-secrets

    cluster:
      name: "${cluster_name}"
    externalServices:
      prometheus:
        secret:
          create: false
          name: prometheus-grafana-cloud
          namespace: grafana-k8s-monitoring
      loki:
        secret:
          create: false
          name: loki-grafana-cloud
          namespace: grafana-k8s-monitoring
      tempo:
        secret:
          create: false
          name: tempo-grafana-cloud
          namespace: grafana-k8s-monitoring
    metrics:
      enabled: true
      extraMetricRelabelingRules: |-
        rule {
            source_labels = ["namespace"]
            regex = "^$|${grafana_k8s_monitor_config.include_namespaces_piped}"
            action = "keep"
        }
      podMonitors:
        namespaces: [${grafana_k8s_monitor_config.include_namespaces}]
      serviceMonitors:
        namespaces: [${grafana_k8s_monitor_config.include_namespaces}]
      alloy:
        metricsTuning:
          useIntegrationAllowList: true
      cost:
        enabled: true
      kepler:
        enabled: true
      node-exporter:
        enabled: true
    logs:
      enabled: true
      pod_logs:
        enabled: true
        excludeNamespaces: [${grafana_k8s_monitor_config.exclude_namespaces}]
      cluster_events:
        enabled: true
    traces:
      enabled: true
    receivers:
      grpc:
        enabled: true
      http:
        enabled: true
      zipkin:
        enabled: true
      grafanaCloudMetrics:
        enabled: false
    opencost:
      enabled: true
      opencost:
        exporter:
          defaultClusterId: "${cluster_name}"
        prometheus:
          existingSecretName: "prometheus-grafana-cloud"
          external:
            url: "${grafana_k8s_monitor_config.grafana_cloud_prometheus_host}"
    kube-state-metrics:
      enabled: true
    prometheus-node-exporter:
      enabled: true
    prometheus-operator-crds:
      enabled: false
    kepler:
      enabled: true
    alloy-events: {}
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: grafana-k8s-monitor-secrets
  namespace: grafana-k8s-monitoring
spec:
  provider: azure
  parameters:
    clientID: ${client_id}
    keyvaultName: ${key_vault_name}
    tenantId: ${tenant_id}
    objects: |
      array:
        - |
          objectName: prometheus-grafana-cloud-host
          objectType: secret
        - |
          objectName: prometheus-grafana-cloud-user
          objectType: secret
        - |
          objectName: prometheus-grafana-cloud-password
          objectType: secret
        - |
          objectName: loki-grafana-cloud-host
          objectType: secret
        - |
          objectName: loki-grafana-cloud-user
          objectType: secret
        - |
          objectName: loki-grafana-cloud-password
          objectType: secret
        - |
          objectName: tempo-grafana-cloud-host
          objectType: secret
        - |
          objectName: tempo-grafana-cloud-user
          objectType: secret
        - |
          objectName: tempo-grafana-cloud-password
          objectType: secret
  secretObjects:
    - secretName: prometheus-grafana-cloud
      type: Opaque
      data:
        - objectName: prometheus-grafana-cloud-host
          key: host
        - objectName: prometheus-grafana-cloud-user
          key: username
        - objectName: prometheus-grafana-cloud-password
          key: password
    - secretName: loki-grafana-cloud
      type: Opaque
      data:
        - objectName: loki-grafana-cloud-host
          key: host
        - objectName: loki-grafana-cloud-user
          key: username
        - objectName: loki-grafana-cloud-password
          key: password
    - secretName: tempo-grafana-cloud
      type: Opaque
      data:
        - objectName: tempo-grafana-cloud-host
          key: host
        - objectName: tempo-grafana-cloud-user
          key: username
        - objectName: tempo-grafana-cloud-password
          key: password
