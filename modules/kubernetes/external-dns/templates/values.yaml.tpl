provider: ${provider}
sources:
  ${yamlencode(sources)}
logFormat: json
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
azure:
  tenantId: ${azure_tenant_id}
  subscriptionId: ${azure_subscription_id}
  resourceGroup: ${azure_resource_group}
  useManagedIdentityExtension: true
