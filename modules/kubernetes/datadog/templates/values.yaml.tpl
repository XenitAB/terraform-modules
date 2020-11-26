datadog:
  apikey: ${api_key}
  clusterName: ${location}-${environment}
  site: datadoghq.eu
  kubeStateMetricsEnabled: true
  clusterChecks:
    enabled: true
  tags:
    - "kubernetesEnvironment:${environment}"
    - "Env:${environment}"
  collectEvents: true
  leaderElection: true
  logs:
    enabled: true
    containerCollectAll: true
  apm:
    enabled: true
  systemProbe:
    enabled: true
  env:
    - name: DD_KUBELET_TLS_VERIFY
      value: "false"
  processAgent:
    enabled: true
    processCollection: true

clusterAgent:
  enabled: true
