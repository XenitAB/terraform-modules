apiVersion: v1
kind: Namespace
metadata:
 name: promtail
 labels:
   name: promtail
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: promtail
  namespace: promtail
spec:
  interval: 1m0s
  url: "https://grafana.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: promtail
  namespace: promtail
spec:
  chart:
    spec:
      chart: promtail
      sourceRef:
        kind: HelmRepository
        name: promtail
      version: 6.6.2
  interval: 1m0s
  values:
    config:
      clients:
        - url: "${loki_address}"
          tls_config:
            cert_file: /mnt/tls/tls.crt
            key_file: /mnt/tls/tls.key
        - url: "${grafana_cloud_address}"
      snippets:
        pipelineStages:
          - cri: {}
          - static_labels:
              region: "${region}"
              environment: "${environment}"
              cluster: "${cluster_name}"

          # Drop 2xx and 3xx from ingress-nginx since it it generates a lot of log messages. Example:
          # xxx.xxx.xxx.xxx - - [04/May/2022:13:12:50 +0000] "POST /api/v1/receive HTTP/2.0" 200 0 "-" "Prometheus/2.35.0"
          # 35234 0.004 [monitor-router-receiver-remote-write] [] 10.244.34.149:19291 0 0.004 200 0156a072a34b23dc09bcfcfe87991c7b
          - match:
              selector: '{namespace="ingress-nginx"}'
              stages:
              - regex:
                  expression: '^(?P<_>[\w\.]+) - (?P<_>[^ ]*) \[(?P<_>.*)\] "(?P<_>[^ ]*) (?P<_>[^ ]*) (?P<_>[^ ]*)" (?P<nginx_status>[\d]+).*'
          - drop:
              source: nginx_status
              expression: "[2-3][0-9][0-9]"
              drop_counter_reason: nginx_ok

        extraRelabelConfigs:
          %{~ for namespace in excluded_namespaces ~}
          - action: drop
            regex: ${namespace}
            source_labels:
              - __meta_kubernetes_namespace
          %{~ endfor ~}
    
    priorityClassName: "platform-high"

    # Tolerate everything
    tolerations:
      - operator: Exists
        effect: NoSchedule

    resources:
      limits:
        memory: 200Mi
      requests:
        cpu: 50m
        memory: 100Mi

    podLabels:
      azure.workload.identity/use: "true"

    extraVolumes:
      - name: secrets-store
        csi:
          driver: secrets-store.csi.k8s.io
          readOnly: true
          volumeAttributes:
            secretProviderClass: promtail
      - name: tls
        secret:
          secretName: "${k8s_secret_name}"

    extraVolumeMounts:
      - name: secrets-store
        mountPath: /mnt/secrets-store
      - name: tls
        mountPath: "/mnt/tls"
        readOnly: true

    serviceAccount:
      create: true
      name: promtail
      annotations:
        azure.workload.identity/client-id: ${client_id}
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: promtail
  namespace: promtail
spec:
  provider: "azure"
  parameters:
    clientID: ${client_id}
    keyvaultName: ${azure_config.azure_key_vault_name}
    tenantId: ${tenant_id}
    objects:  |
      array:
        - |
          objectName: "${azure_config.keyvault_secret_name}"
          objectType: secret
  secretObjects:
    - secretName: "${k8s_secret_name}"
      type: kubernetes.io/tls
      data:
        - objectName: "${azure_config.keyvault_secret_name}"
          key: tls.key
        - objectName: "${azure_config.keyvault_secret_name}"
          key: tls.crt
---
apiVersion: v1
kind: Service
metadata:
  name: promtail-metrics
  namespace: promtail
  labels:
    app.kubernetes.io/instance: promtail
    app.kubernetes.io/name: promtail
spec:
  clusterIP: None
  ports:
    - name: http-metrics
      port: 3101
      targetPort: http-metrics
      protocol: TCP
  selector:
    app.kubernetes.io/instance: promtail
    app.kubernetes.io/name: promtail

