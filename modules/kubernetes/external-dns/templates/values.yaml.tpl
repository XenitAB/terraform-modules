provider: "${provider}"
sources:
  ${yamlencode(sources)}
logFormat: json
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
%{ if provider == "azure" }
azure:
  tenantId: "${azure_tenant_id}"
  subscriptionId: "${azure_subscription_id}"
  resourceGroup: "${azure_resource_group}"
  useManagedIdentityExtension: true
podLabels:
  aadpodidbinding: external-dns
%{ endif }
