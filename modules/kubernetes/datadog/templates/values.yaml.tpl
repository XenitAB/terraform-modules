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
    containerCollectAll: false
    containerCollectUsingFiles: true
  apm:
    enabled: true
  systemProbe:
    enabled: false
  processAgent:
    enabled: true
    processCollection: true
  containerExcludeLogs: "kube_namespace:kube-system kube_namespace:datadog"
  env:
    - name: DD_CONTAINER_INCLUDE
      value: ${container_include}

agents:
  tolerations:
    - operator: "Exists"
  priorityClassName: platform-high

clusterAgent:
  enabled: true
  priorityClassName: platform-low
