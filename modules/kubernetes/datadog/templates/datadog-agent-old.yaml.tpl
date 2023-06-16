#Currently not used, keeping in case of rollback.
apiVersion: datadoghq.com/v1alpha1
kind: DatadogAgent
metadata:
  name: datadog
  namespace: datadog
spec:
  clusterName: ${location}-${environment}
  site: ${datadog_site}
  credentials:
    apiSecret:
      secretName: datadog-operator-apikey
      keyName: api-key
    appSecret:
      secretName: datadog-operator-appkey
      keyName: app-key
  agent:
    priorityClassName: platform-high
    image:
      name: "gcr.io/datadoghq/agent:latest"
    log:
      enabled: true
      logsConfigContainerCollectAll: true
    apm:
      enabled: true
      hostPort: 8126
    env:
      - name: DD_CONTAINER_EXCLUDE_LOGS
        value: "name:datadog-agent"
      - name: DD_CONTAINER_INCLUDE
        value: "kube_namespace: ${namespace_include}"
      - name: DD_CONTAINER_EXCLUDE
        value: "kube_namespace:.*"
      - name: DD_APM_IGNORE_RESOURCES
        value: ${apm_ignore_resources} 
    config:
      tolerations:
        - operator: Exists
      tags:
        - "env: ${environment}"
      kubelet:
        tlsVerify: false
      criSocket:
        criSocketPath: /var/run/containerd/containerd.sock
      volumeMounts:
        - name: containerdsocket
          mountPath: /var/run/containerd/containerd.sock
      volumes:
        - hostPath:
            path: /var/run/containerd/containerd.sock
          name: containerdsocket
        - hostPath:
            path: /var/run
          name: var-run
      resources:
        requests:
          cpu: 60m
          memory: 200Mi
  clusterAgent:
    replicas: 2
    priorityClassName: platform-low
    config:
      resources:
        requests:
          cpu: 60m
          memory: 200Mi
    image:
      name: "gcr.io/datadoghq/cluster-agent:latest"
  features:
    kubeStateMetricsCore:
      enabled: true
    logCollection:
      enabled: true
      logsConfigContainerCollectAll: true
