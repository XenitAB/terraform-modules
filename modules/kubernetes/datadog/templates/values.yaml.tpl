datadog:
  apiKey: ${api_key}
  clusterName: ${location}-${environment}
  site: ${datadog_site}
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
    containerCollectUsingFiles: true
  apm:
    enabled: true
  systemProbe:
    enabled: false
  processAgent:
    enabled: true
    processCollection: true
  containerExcludeLogs: "kube_namespace:kube-system kube_namespace:datadog"

agents:
  tolerations:
    - operator: "Exists"

clusterAgent:
  enabled: true
