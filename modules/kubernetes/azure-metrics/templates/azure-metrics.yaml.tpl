apiVersion: v1
kind: Namespace
metadata:
 name: azure-metrics
 labels:
   name              = "azure-metrics"
   xkf.xenit.io/kind = "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: azure-metrics
  namespace: azure-metrics
spec:
  interval: 1m0s
  url: "https://webdevops.github.io/helm-charts/"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: azure-metrics
  namespace: azure-metrics
spec:
  chart:
    spec:
      chart: azure-metrics-exporter
      sourceRef:
        kind: HelmRepository
        name: azure-metrics
      version: v1.2.1
  interval: 1m0s
  values:
    image:
      repository: webdevops/azure-metrics-exporter
      pullPolicy: IfNotPresent
      # Overrides the image tag whose default is the chart appVersion.
      tag: "22.3.0"

    imagePullSecrets: []
    nameOverride: ""
    fullnameOverride: ""

    podAnnotations: {}

    podSecurityContext:
      {}
      # fsGroup: 2000

    securityContext:
      {}
      # capabilities:
      #   drop:
      #   - ALL
      # readOnlyRootFilesystem: true
      # runAsNonRoot: true
      # runAsUser: 1000

    service:
      type: ClusterIP
      port: 80

    resources:
      requests:
        cpu: 15m
        memory: 25Mi

    nodeSelector: {}

    tolerations: []

    affinity: {}

    aadpodidbinding:
      name: azure-metrics
      enabled: true

    podmonitor:
      loadBalancer: true
      kubernetes: true

    subscription: ""
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: azure-metrics
spec:
  type: 0
  resourceID: ${resource_id}
  clientID: ${client_id}
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: azure-metrics
spec:
  azureIdentity: azure-metrics
  selector: azure-metrics
---
{{- if .Values.podmonitor.loadBalancer }}
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  labels:
    {{- include "azure-metrics-exporter.labels" . | nindent 4 }}
    xkf.xenit.io/monitoring: platform
  name: {{ include "azure-metrics-exporter.fullname" . }}-loadbalancers
spec:
  podMetricsEndpoints:
  - interval: 60s
    port: http
    path: /probe/metrics/list
    params:
      name: ["azure-metric"]
      subscription:
        - {{ .Values.subscription }}
      template:
        - '{name}_{metric}_{aggregation}_{unit}'
      resourceType:
        - Microsoft.Network/loadBalancers
      aggregation:
        - average
        - total
      metric:
        - SnatConnectionCount
        - AllocatedSnatPorts
        - UsedSnatPorts
  selector:
    matchLabels:
      {{- include "azure-metrics-exporter.selectorLabels" . | nindent 6 }}
{{- end }}
---
{{- if .Values.podmonitor.kubernetes }}
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  labels:
    {{- include "azure-metrics-exporter.labels" . | nindent 4 }}
    xkf.xenit.io/monitoring: platform
  name: {{ include "azure-metrics-exporter.fullname" . }}-kubernetes
spec:
  podMetricsEndpoints:
  - interval: 60s
    port: http
    path: /probe/metrics/list
    params:
      name: ["azure-metric"]
      subscription:
        - {{ .Values.subscription }}
      template:
        - '{metric}'
      resourceType:
        - Microsoft.ContainerService/managedClusters
      aggregation:
        - average
        - total
      metric:
        - cluster_autoscaler_cluster_safe_to_autoscale
        - cluster_autoscaler_scale_down_in_cooldown
        - cluster_autoscaler_unneeded_nodes_count
        - cluster_autoscaler_unschedulable_pods_count
  selector:
    matchLabels:
      {{- include "azure-metrics-exporter.selectorLabels" . | nindent 6 }}
{{- end }}
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  labels:
    {{- include "azure-metrics-exporter.labels" . | nindent 4 }}
    xkf.xenit.io/monitoring: platform
  name: {{ include "azure-metrics-exporter.fullname" . }}
spec:
  podMetricsEndpoints:
  - interval: 60s
    port: http
    path: /metrics
  selector:
    matchLabels:
      {{- include "azure-metrics-exporter.selectorLabels" . | nindent 6 }}
