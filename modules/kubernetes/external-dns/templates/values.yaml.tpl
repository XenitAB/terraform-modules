provider: ${provider}
sources:
  ${yamlencode(sources)}
logFormat: json
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
azure:
  useManagedIdentityExtension: true
