apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-alloy-config
  namespace: grafana-alloy
data:
  config.alloy: |-
    /********************************************
     * METRICS COLLECTION
     ********************************************/
    
    // Discover ServiceMonitors
    discovery.kubernetes "servicemonitors" {
      role = "pod"
      
      namespaces {
        own_namespace = false
      }
      
      selectors {
        role = "pod"
        label = "xkf.xenit.io/monitoring=tenant"
      }
    }
    
    // Discover PodMonitors
    discovery.kubernetes "podmonitors" {
      role = "pod"
      
      namespaces {
        own_namespace = false
      }
      
      selectors {
        role = "pod"
        label = "xkf.xenit.io/monitoring=tenant"
      }
    }
    
    // Scrape metrics from discovered targets
    prometheus.scrape "default" {
      targets    = discovery.kubernetes.servicemonitors.targets
      forward_to = [prometheus.relabel.default.receiver]
    }
    
    prometheus.scrape "pods" {
      targets    = discovery.kubernetes.podmonitors.targets
      forward_to = [prometheus.relabel.default.receiver]
    }
    
    // Add cluster and environment labels
    prometheus.relabel "default" {
      forward_to = [prometheus.remote_write.metrics.receiver]
      
      rule {
        target_label = "cluster"
        replacement  = "${cluster_name}"
      }
      
      rule {
        target_label = "environment"
        replacement  = "${environment}"
      }
    }
    
    %{ if remote_write_metrics_url != "" }
    // Load credentials from mounted secret
    local.file "metrics_username" {
      filename = "/mnt/secrets-store/metrics_username"
    }
    
    local.file "metrics_password" {
      filename = "/mnt/secrets-store/metrics_password"
    }
    
    // Remote write for metrics
    prometheus.remote_write "metrics" {
      endpoint {
        url = "${remote_write_metrics_url}"
        
        basic_auth {
          username = nonsensitive(local.file.metrics_username.content)
          password = local.file.metrics_password.content
        }
        
        queue_config {
          capacity             = 10000
          min_shards           = 1
          max_shards           = 50
          max_samples_per_send = 2000
          batch_send_deadline  = "5s"
          min_backoff          = "30ms"
          max_backoff          = "5s"
          retry_on_http_429    = true
        }
      }
      
      wal {
        truncate_frequency = "2h"
        min_keepalive_time = "5m"
        max_keepalive_time = "8h"
      }
    }
    %{ endif }
    
    /********************************************
     * LOGS COLLECTION
     ********************************************/
    
    %{ if remote_write_logs_url != "" }
    // Load credentials from mounted secret
    local.file "logs_username" {
      filename = "/mnt/secrets-store/logs_username"
    }
    
    local.file "logs_password" {
      filename = "/mnt/secrets-store/logs_password"
    }
    
    // Discover pods for log collection
    discovery.kubernetes "pods" {
      role = "pod"
      
      namespaces {
        own_namespace = false
      }
      
      selectors {
        role = "pod"
        label = "xkf.xenit.io/monitoring=tenant"
      }
    }
    
    // Collect pod logs
    discovery.relabel "pod_logs" {
      targets = discovery.kubernetes.pods.targets
      
      rule {
        source_labels = ["__meta_kubernetes_namespace"]
        target_label  = "namespace"
      }
      
      rule {
        source_labels = ["__meta_kubernetes_pod_name"]
        target_label  = "pod"
      }
      
      rule {
        source_labels = ["__meta_kubernetes_pod_container_name"]
        target_label  = "container"
      }
    }
    
    loki.source.kubernetes "pods" {
      targets    = discovery.relabel.pod_logs.output
      forward_to = [loki.process.pod_logs.receiver]
    }
    
    // Process logs (CRI format)
    loki.process "pod_logs" {
      forward_to = [loki.relabel.pod_logs.receiver]
      
      stage.cri {}
      
      stage.labels {
        values = {
          cluster     = "${cluster_name}",
          environment = "${environment}",
        }
      }
    }
    
    loki.relabel "pod_logs" {
      forward_to = [loki.write.logs.receiver]
      
      rule {
        target_label = "cluster"
        replacement  = "${cluster_name}"
      }
      
      rule {
        target_label = "environment"
        replacement  = "${environment}"
      }
    }
    
    // Write logs to remote endpoint
    loki.write "logs" {
      endpoint {
        url = "${remote_write_logs_url}"
        
        basic_auth {
          username = nonsensitive(local.file.logs_username.content)
          password = local.file.logs_password.content
        }
      }
    }
    %{ endif }
    
    /********************************************
     * TRACES COLLECTION
     ********************************************/
    
    %{ if remote_write_traces_url != "" }
    // Load credentials from mounted secret
    local.file "traces_username" {
      filename = "/mnt/secrets-store/traces_username"
    }
    
    local.file "traces_password" {
      filename = "/mnt/secrets-store/traces_password"
    }
    
    // OTLP receiver
    otelcol.receiver.otlp "default" {
      grpc {
        endpoint = "0.0.0.0:4317"
      }
      
      http {
        endpoint = "0.0.0.0:4318"
      }
      
      output {
        metrics = [otelcol.processor.batch.default.input]
        logs    = [otelcol.processor.batch.default.input]
        traces  = [otelcol.processor.batch.default.input]
      }
    }
    
    // Jaeger receiver (legacy support)
    otelcol.receiver.jaeger "default" {
      protocols {
        grpc {
          endpoint = "0.0.0.0:55678"
        }
      }
      
      output {
        traces = [otelcol.processor.batch.default.input]
      }
    }
    
    // Batch processor
    otelcol.processor.batch "default" {
      output {
        metrics = [otelcol.exporter.otlphttp.default.input]
        logs    = [otelcol.exporter.otlphttp.default.input]
        traces  = [otelcol.exporter.otlphttp.default.input]
      }
    }
    
    // Basic auth for OTLP export
    otelcol.auth.basic "default" {
      username = nonsensitive(local.file.traces_username.content)
      password = local.file.traces_password.content
    }
    
    // Export to remote endpoint
    otelcol.exporter.otlphttp "default" {
      client {
        endpoint = "${remote_write_traces_url}"
        auth     = otelcol.auth.basic.default.handler
      }
    }
    %{ endif }
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: grafana-alloy
rules:
  - apiGroups:
      - ""
    resources:
      - nodes
      - nodes/proxy
      - nodes/metrics
      - services
      - endpoints
      - pods
      - events
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - networking.k8s.io
    resources:
      - ingresses
    verbs:
      - get
      - list
      - watch
  - nonResourceURLs:
      - /metrics
      - /metrics/cadvisor
    verbs:
      - get
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: grafana-alloy
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: grafana-alloy
subjects:
  - kind: ServiceAccount
    name: grafana-alloy
    namespace: grafana-alloy
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: grafana-alloy-credentials
  namespace: grafana-alloy
spec:
  provider: azure
  parameters:
    clientID: ${client_id}
    keyvaultName: ${azure_config.azure_key_vault_name}
    tenantId: ${tenant_id}
    objects: |
      array:
        - |
          objectName: grafana-metrics-username
          objectType: secret
          objectAlias: metrics_username
        - |
          objectName: grafana-metrics-password
          objectType: secret
          objectAlias: metrics_password
        - |
          objectName: grafana-logs-username
          objectType: secret
          objectAlias: logs_username
        - |
          objectName: grafana-logs-password
          objectType: secret
          objectAlias: logs_password
        - |
          objectName: grafana-traces-username
          objectType: secret
          objectAlias: traces_username
        - |
          objectName: grafana-traces-password
          objectType: secret
          objectAlias: traces_password
  secretObjects:
    - secretName: ${credentials_secret_name}
      type: Opaque
      data:
        - objectName: metrics_username
          key: metrics_username
        - objectName: metrics_password
          key: metrics_password
        - objectName: logs_username
          key: logs_username
        - objectName: logs_password
          key: logs_password
        - objectName: traces_username
          key: traces_username
        - objectName: traces_password
          key: traces_password
---
%{ if ingress_nginx_observability }
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: tenant
  name: ingress-nginx-controller
  namespace: grafana-alloy
spec:
  endpoints:
  - interval: 30s
    port: http-metrics
  namespaceSelector:
    matchNames:
    - ingress-nginx
  selector:
    matchLabels:
      app.kubernetes.io/component: controller
      app.kubernetes.io/name: ingress-nginx
      function: metrics
---
%{ endif }
%{ if include_kubelet_metrics }
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: tenant
  name: kubelet-monitor
  namespace: grafana-alloy
spec:
  endpoints:
    - bearerTokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token
      honorLabels: true
      metricRelabelings:
        - action: keep
          regex: ${kubelet_metrics_namespaces}
          sourceLabels:
            - namespace
        - action: keep
          regex: container_cpu_usage_seconds_total|container_network_transmit_bytes_total|container_network_receive_bytes_total|container_memory_swap|container_network_receive_packets_total|container_cpu_cfs_periods_total|container_cpu_cfs_throttled_periods_total|node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate|container_memory_working_set_bytes|container_memory_rss|container_network_receive_packets_dropped_total|container_start_time_seconds|container_network_transmit_packets_dropped_total|container_memory_cache|container_network_transmit_packets_total
          sourceLabels:
            - __name__
        - action: labeldrop
          regex: endpoint|id|job|metrics_path|service|name|instance
      port: https-metrics
      relabelings:
        - action: replace
          sourceLabels:
            - __metrics_path__
          targetLabel: metrics_path
      scheme: https
      tlsConfig:
        caFile: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecureSkipVerify: true
    - bearerTokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token
      honorLabels: true
      metricRelabelings:
        - action: keep
          regex: ${kubelet_metrics_namespaces}
          sourceLabels:
            - namespace
        - action: keep
          regex: container_cpu_usage_seconds_total|container_network_transmit_bytes_total|container_network_receive_bytes_total|container_memory_swap|container_network_receive_packets_total|container_cpu_cfs_periods_total|container_cpu_cfs_throttled_periods_total|node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate|container_memory_working_set_bytes|container_memory_rss|container_network_receive_packets_dropped_total|container_start_time_seconds|container_network_transmit_packets_dropped_total|container_memory_cache|container_network_transmit_packets_total
          sourceLabels:
            - __name__
        - action: labeldrop
          regex: endpoint|id|job|metrics_path|service|name|instance
      path: /metrics/cadvisor
      port: https-metrics
      relabelings:
        - action: replace
          sourceLabels:
            - __metrics_path__
          targetLabel: metrics_path
      scheme: https
      tlsConfig:
        caFile: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecureSkipVerify: true
    - bearerTokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token
      honorLabels: true
      metricRelabelings:
        - action: keep
          regex: ${kubelet_metrics_namespaces}
          sourceLabels:
            - namespace
        - action: keep
          regex: container_cpu_usage_seconds_total|container_network_transmit_bytes_total|container_network_receive_bytes_total|container_memory_swap|container_network_receive_packets_total|container_cpu_cfs_periods_total|container_cpu_cfs_throttled_periods_total|node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate|container_memory_working_set_bytes|container_memory_rss|container_network_receive_packets_dropped_total|container_start_time_seconds|container_network_transmit_packets_dropped_total|container_memory_cache|container_network_transmit_packets_total
          sourceLabels:
            - __name__
        - action: labeldrop
          regex: endpoint|id|job|metrics_path|service|name|instance
      path: /metrics/probes
      port: https-metrics
      relabelings:
        - action: replace
          sourceLabels:
            - __metrics_path__
          targetLabel: metrics_path
      scheme: https
      tlsConfig:
        caFile: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecureSkipVerify: true
  jobLabel: k8s-app
  namespaceSelector:
    matchNames:
      - kube-system
  selector:
    matchLabels:
      app.kubernetes.io/name: kubelet
      k8s-app: kubelet
%{ endif }
