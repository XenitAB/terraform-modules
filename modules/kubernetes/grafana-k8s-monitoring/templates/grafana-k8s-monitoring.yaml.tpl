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
      version: 2.0.8

  values:
    global:
      scrapeInterval: "90s"
    cluster:
      name: "${cluster_name}"
    destinations:
      - name: xenitsweden-prom
        type: prometheus
        url: https://prometheus-prod-39-prod-eu-north-0.grafana.net/api/prom/push
        auth:
          type: basic
          username: username
          password: password
        secret:
          create: false
          name: prometheus-grafana-cloud
          namespace: grafana-k8s-monitoring
      - name: xenitsweden-logs
        type: loki
        url: https://logs-prod-025.grafana.net/loki/api/v1/push
        auth:
          type: basic
          username: username
          password: password
        secret:
          create: false
          name: loki-grafana-cloud
          namespace: grafana-k8s-monitoring
      - name: xenitsweden-traces
        type: otlp
        url: https://tempo-prod-18-prod-eu-north-0.grafana.net:443
        protocol: grpc
        auth:
          type: basic
          username: username
          password: password
        secret:
          create: false
          name: tempo-grafana-cloud
          namespace: grafana-k8s-monitoring
        metrics:
          enabled: false
        logs:
          enabled: false
        traces:
          enabled: true
    clusterMetrics:
      enabled: true
      %{ if length(node_exporter_node_affinity) > 0 }
      node-exporter:
        affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              nodeSelectorTerms:
                - matchExpressions:
                    %{~ for key, value in node_exporter_node_affinity ~}
                    - key: ${key}
                      operator: NotIn
                      values: [${value}]
                    %{~ endfor ~}
      %{ endif }
      kube-state-metrics:
      %{ if length(exclude_namespaces) > 0 }
        extraMetricProcessingRules: |-
          rule {
            source_labels = ["namespace"]
            regex = "${join("|", exclude_namespaces)}"
            action = "drop"
          }
      %{ endif }
        podAnnotations: {kubernetes.azure.com/set-kube-service-host-fqdn: "true"}
      opencost:
        enabled: false
      kepler:
        enabled: true
    annotationAutodiscovery:
      enabled: true
    prometheusOperatorObjects:
      crds:
        deploy: true
      enabled: true
      podMonitors:
        enabled: true
        excludeNamespaces: 
      %{ for ns in exclude_namespaces ~}
    - ${ns}
      %{ endfor }
      serviceMonitors:
        enabled: true
        excludeNamespaces: 
      %{ for ns in exclude_namespaces ~}
    - ${ns}
      %{ endfor }
    clusterEvents:
      enabled: true

    podLogs:
      enabled: true
      %{ if length(exclude_namespaces) > 0 }
      extraDiscoveryRules: |-
        rule {
          source_labels = ["__meta_kubernetes_namespace"]
          regex = "${join("|", exclude_namespaces)}"
          action = "drop"
        }
      %{ endif }
      excludeNamespaces: 
    %{ for ns in exclude_namespaces ~}
   - ${ns}
    %{ endfor }

    applicationObservability:
      enabled: true
      receivers:
        otlp:
          grpc:
            enabled: true
            port: 4317
          http:
            enabled: true
            port: 4318
        zipkin:
          enabled: true
          port: 9411
      processors:
        grafanaCloudMetrics:
          enabled: true
    
    integrations:
      alloy:
        instances:
          - name: alloy
            labelSelectors:
              app.kubernetes.io/name:
                - alloy-metrics
                - alloy-singleton
                - alloy-logs
                - alloy-receiver
    
    alloy-metrics:
      enabled: true
      alloy:
        storagePath: /var/lib/alloy
        mounts:
          extra:
            - name: secret-store
              mountPath: "/mnt/secrets-store"
              readOnly: true
      controller:
        podAnnotations: {kubernetes.azure.com/set-kube-service-host-fqdn: "true"}
        enableStatefulSetAutoDeletePVC: true
        volumes:
          extra:
            - name: secret-store
              csi:
                driver: secrets-store.csi.k8s.io
                readOnly: true
                volumeAttributes:
                  secretProviderClass: grafana-k8s-monitor-secrets

    alloy-singleton:
      enabled: true
      controller:
        podAnnotations: {kubernetes.azure.com/set-kube-service-host-fqdn: "true"}
    alloy-logs:
      enabled: true
      controller:
        podAnnotations: {kubernetes.azure.com/set-kube-service-host-fqdn: "true"}
    alloy-receiver:
      enabled: true
      alloy:
        extraPorts:
          - name: otlp-grpc
            port: 4317
            targetPort: 4317
            protocol: TCP
          - name: otlp-http
            port: 4318
            targetPort: 4318
            protocol: TCP
          - name: zipkin
            port: 9411
            targetPort: 9411
            protocol: TCP

    crds:
      deploy: true

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
