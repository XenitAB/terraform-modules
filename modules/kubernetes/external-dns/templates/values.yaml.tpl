provider: "${provider}"
sources:
  ${yamlencode(sources)}
logFormat: json
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
%{ if provider == "azure" }
azure:
  tenantId: "${azure_config.tenant_id}"
  subscriptionId: "${azure_config.subscription_id}"
  resourceGroup: "${azure_config.resource_group}"
  useManagedIdentityExtension: true
podLabels:
  aadpodidbinding: external-dns
%{ endif }
%{ if provider == "aws" }
aws:
  region: "${aws_config.region}"
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "${aws_config.role_arn}"
%{ endif }
