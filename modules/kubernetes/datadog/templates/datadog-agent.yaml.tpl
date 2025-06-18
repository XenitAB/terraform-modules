apiVersion: datadoghq.com/v2alpha1
kind: DatadogAgent
metadata:
  name: datadog
  namespace: datadog
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  global:
    clusterName: ${location}-${environment}
    site: ${datadog_site}
    criSocketPath: /var/run/containerd/containerd.sock
    kubelet:
      tlsVerify: false
    credentials:
        apiSecret:
          secretName: datadog-operator-apikey
          keyName: api-key
        appSecret:
          secretName: datadog-operator-appkey
          keyName: app-key
  override:
    nodeAgent:
      priorityClassName: platform-high
      tolerations:
        - operator: Exists
      image:
        name: "gcr.io/datadoghq/agent:7.66.0"
      env:
        - name: DD_CONTAINER_EXCLUDE_LOGS
          value: "name:datadog-agent"
        - name: DD_CONTAINER_INCLUDE
          value: ${namespace_include}
        - name: DD_CONTAINER_EXCLUDE
          value: "kube_namespace:.*"
        - name: DD_APM_IGNORE_RESOURCES
          value: ${apm_ignore_resources}
    clusterAgent:
      replicas: 2
      priorityClassName: platform-low
      image:
        name: "gcr.io/datadoghq/cluster-agent:7.66.0"
      tolerations:
        - operator: Exists
      containers:
        config:
          resources:
            requests:
              cpu: 60m
              memory: 200Mi
  features:
    kubeStateMetricsCore:
      enabled: true
    logCollection:
      enabled: true
      containerCollectAll: true
    apm:
      enabled: true
      hostPortConfig:
        enabled: true 
        hostPort: 8126
    admissionController:
      enabled: false
    otlp:
      receiver:
        protocols:
          http:
            enabled: true
