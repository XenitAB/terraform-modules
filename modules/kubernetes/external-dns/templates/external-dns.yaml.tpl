apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: external-dns
  namespace: external-dns
spec:
  interval: 1m0s
  type: "oci"
  url: "oci://registry-1.docker.io/bitnamicharts"
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
      version: 8.7.3
  interval: 1m0s
  values:
    provider: "azure"
    sources:
      %{~ for item in sources ~}
      - "${item}"
      %{~ endfor ~}
    %{~ if length(extra_args) > 0 ~}
    extraArgs:
      %{~ for arg in extra_args ~}
      - "${arg}"
      %{~ endfor ~}
    %{~ endif ~}
    logFormat: json
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
    serviceAccount:
      annotations:
        azure.workload.identity/client-id: ${client_id}
    podLabels: 
      azure.workload.identity/use: "true"
    azure:
      useWorkloadIdentityExtension: true
      tenantId: "${tenant_id}"
      subscriptionId: "${subscription_id}"
      resourceGroup: "${resource_group_name}"
    policy: sync # will also delete the record
    registry: "txt"
    txtOwnerId: "${txt_owner_id}"
    priorityClassName: "platform-low"
    resources:
      requests:
        cpu: 15m
        memory: 78Mi
