
apiVersion: v1
kind: Namespace
metadata:
 name: datadog
 labels:
   name              = "datadog"
   xkf.xenit.io/kind = "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: datadog
  namespace: datadog
spec:
  interval: 1m0s
  url: "https://helm.datadoghq.com"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: datadog-operator
  namespace: datadog
spec:
  chart:
    spec:
      chart: datadog-operator
      sourceRef:
        kind: HelmRepository
        name: datadog
      version: 0.8.0
  values:
    appKey: ${app_key}
    apiKey: ${api_key}
    installCRDs: true
    datadogMonitor:
      enabled: true
    resources:
      requests:
        cpu: 15m
        memory: 50Mi
  interval: 1m0s
---
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