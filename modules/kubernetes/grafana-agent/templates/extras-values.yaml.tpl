environment: ${environment}
clusterName: ${cluster_name}
credentialsSecretName: ${credentials_secret_name}

remote:
  metricsUrl: ${remote_write_metrics_url}
  logsUrl: ${remote_write_logs_url}
  tracesUrl: ${remote_write_traces_url}

ingressNginx: ${ingress_nginx_observability}
includeKubeletMetrics: ${include_kubelet_metrics}
kubeletMetricsNamespaces: ${kubelet_metrics_namespaces}

