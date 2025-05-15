apiVersion: monitoring.grafana.com/v1alpha1
kind: GrafanaAgent
metadata:
  name: grafana-agent
  namespace: grafana-agent
  labels:
    app: grafana-agent
spec:
  image: grafana/agent:v0.40.4
  logLevel: info
  serviceAccountName: grafana-agent
  priorityClassName: platform-medium
  metrics:
    instanceSelector:
      matchLabels:
        agent: grafana-agent-metrics
    replicas: 2
    externalLabels:
      cluster: ${cluster_name}
      environment: ${environment}
  logs:
    instanceSelector:
      matchLabels:
        agent: grafana-agent-logs
  resources:
    requests:
      cpu: 25m
      memory: 100Mi
  tolerations:
    - operator: "Exists"
---
%{ if remote_write_logs_url != "" }
apiVersion: monitoring.grafana.com/v1alpha1
kind: LogsInstance
metadata:
  name: primary
  namespace: grafana-agent
  labels:
    agent: grafana-agent-logs
spec:
  clients:
    - url: ${remote_write_logs_url}
      externalLabels:
        cluster: ${cluster_name }
        environment: ${environment }
      basicAuth:
        username:
          name: ${credentials_secret_name}
          key: logs_username
        password:
          name: ${credentials_secret_name}
          key: logs_password
  podLogsNamespaceSelector:
    matchExpressions:
      - key: "xkf.xenit.io/kind"
        operator: "Exists"
  podLogsSelector:
    matchLabels:
      xkf.xenit.io/monitoring: tenant
---
%{ endif }
%{ if remote_write_metrics_url != "" }
apiVersion: monitoring.grafana.com/v1alpha1
kind: MetricsInstance
metadata:
  name: primary
  namespace: grafana-agent
  labels:
    agent: grafana-agent-metrics
spec:
  remoteWrite:
    - url: ${remote_write_metrics_url}
      basicAuth:
        username:
          name: ${credentials_secret_name}
          key: metrics_username
        password:
          name: ${credentials_secret_name}
          key: metrics_password
  serviceMonitorNamespaceSelector:
    matchExpressions:
      - key: "xkf.xenit.io/kind"
        operator: "Exists"
  serviceMonitorSelector:
    matchLabels:
      xkf.xenit.io/monitoring: tenant
  podMonitorNamespaceSelector:
    matchExpressions:
      - key: "xkf.xenit.io/kind"
        operator: "Exists"
  podMonitorSelector:
    matchLabels:
      xkf.xenit.io/monitoring: tenant
  probeNamespaceSelector:
    matchExpressions:
      - key: "xkf.xenit.io/kind"
        operator: "Exists"
  probeSelector:
    matchLabels:
      xkf.xenit.io/monitoring: tenant
---
%{ endif }
%{ if ingress_nginx_observability }
apiVersion: monitoring.grafana.com/v1alpha1
kind: PodLogs
metadata:
  name: ingress-nginx-controller
  labels:
    xkf.xenit.io/monitoring: tenant
spec:
  selector:
    matchLabels:
      app.kubernetes.io/component: controller
      app.kubernetes.io/name: ingress-nginx
  namespaceSelector:
    matchNames:
    - ingress-nginx
  pipelineStages:
    - cri: {}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    xkf.xenit.io/monitoring: tenant
  name: ingress-nginx-controller
  namespace: grafana-agent
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
  namespace: grafana-agent
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
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: grafana-agent
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
  name: grafana-agent
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: grafana-agent
subjects:
  - kind: ServiceAccount
    name: grafana-agent
    namespace: grafana-agent
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: grafana-agent-traces
  namespace: grafana-agent
data:
  agent.yaml: |
    server:
      log_level: debug
    tempo:
      configs:
        - name: default
          remote_write:
            - endpoint: $${TRACES_REMOTE_WRITE_URL}
              basic_auth:
                username: $${TRACES_USERNAME}
                password: $${TRACES_PASSWORD}
          receivers:
            otlp:
              protocols:
                http: {}
                grpc: {}
            jaeger:
              protocols:
                grpc:
                  endpoint: 0.0.0.0:55678
---
%{ if remote_write_traces_url != "" }
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    reloader.stakater.com/auto: "true"
  name: grafana-agent-traces
  namespace: grafana-agent
spec:
  minReadySeconds: 10
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      name: grafana-agent-traces
  template:
    metadata:
      labels:
        name: grafana-agent-traces
    spec:
      priorityClassName: "platform-medium"
      containers:
        - args:
            - -config.file=/etc/agent/agent.yaml
            - -config.expand-env
          command:
            - /bin/agent
          env:
            - name: HOSTNAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: TRACES_USERNAME
              valueFrom:
                secretKeyRef:
                  name: ${credentials_secret_name}
                  key: traces_username
            - name: TRACES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: ${credentials_secret_name}
                  key: traces_password
            - name: TRACES_REMOTE_WRITE_URL
              value: "${remote_write_traces_url}"
          image: grafana/agent:v0.21.2
          imagePullPolicy: IfNotPresent
          name: agent
          ports:
            - containerPort: 8080
              name: http-metrics
            - containerPort: 4318
              name: otlp-http
              protocol: TCP
            - containerPort: 4317
              name: otlp-grpc
              protocol: TCP
            - containerPort: 55681
              name: otlp-legacy
              protocol: TCP
            - containerPort: 55678
              name: jaeger
              protocol: TCP
          volumeMounts:
            - mountPath: /etc/agent
              name: grafana-agent-traces
          resources:
            requests:
              cpu: 20m
              memory: 50Mi
      serviceAccount: grafana-agent
      volumes:
        - configMap:
            name: grafana-agent-traces
          name: grafana-agent-traces
---
apiVersion: v1
kind: Service
metadata:
  labels:
    name: grafana-agent-traces
  name: grafana-agent-traces
  namespace: grafana-agent
spec:
  ports:
    - name: agent-http-metrics
      port: 8080
      targetPort: 8080
    - name: otlp-http
      port: 4318
      protocol: TCP
      targetPort: otlp-http
    - name: otlp-grpc
      port: 4317
      protocol: TCP
      targetPort: otlp-grpc
    - name: otlp-legacy
      port: 55681
      protocol: TCP
      targetPort: otlp-legacy
    - name: jaeger
      port: 55678
      protocol: TCP
      targetPort: jaeger
  selector:
    name: grafana-agent-traces
%{ endif }
---
apiVersion: v1
kind: Secret
metadata:
  name: ${credentials_secret_name}
  namespace: grafana-agent
data:
  metrics_username: ${metrics_username}
  metrics_password: ${metrics_password}
  logs_username: ${logs_username}
  logs_password: ${logs_password}
  traces_username: ${traces_username}
  traces_password: ${traces_password}

