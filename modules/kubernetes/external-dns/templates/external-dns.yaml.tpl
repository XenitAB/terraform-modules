apiVersion: v1
kind: Namespace
metadata:
 name: external-dns
 labels:
   name: "external-dns"
   xkf.xenit.io/kind: "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: external-dns
  namespace: external-dns
spec:
  interval: 1m0s
  url: "https://charts.bitnami.com/bitnami"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: external-dns
  namespace: external-dns
spec:
  chart:
    spec:
      chart: external-dns
      sourceRef:
        kind: HelmRepository
        name: external-dns
      version: 7.1.0
  interval: 1m0s
  values:
    provider: "azure"
    sources:
      %{~ for item in sources ~}
      - "${item}"
      %{~ endfor ~}
    logFormat: json
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
    serviceAccount:
      annotations:
        azure.workload.identity/client-id: ${azure_config.client_id}
    podLabels: 
      azure.workload.identity/use: "true"
    azure:
      useWorkloadIdentityExtension: true
      tenantId: "${azure_config.tenant_id}"
      subscriptionId: "${azure_config.subscription_id}"
      resourceGroup: "${azure_config.resource_group}"
    policy: sync # will also delete the record
    registry: "txt"
    txtOwnerId: "${txt_owner_id}"
    priorityClassName: "platform-low"
    resources:
      requests:
        cpu: 15m
        memory: 78Mi
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: external-dns
  namespace: external-dns
  labels:
    xkf.xenit.io/monitoring: platform
spec:
  endpoints:
  - path: /metrics
    port: http
  namespaceSelector:
    matchNames:
    - external-dns
  selector:
    matchLabels:
      app.kubernetes.io/instance: external-dns
      app.kubernetes.io/name: external-dns
