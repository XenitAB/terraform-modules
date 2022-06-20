provider: "${provider}"
sources:
  %{~ for item in sources ~}
  - "${item}"
  %{~ endfor ~}
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
policy: sync # will also delete the record
registry: "txt"
txtOwnerId: "${txt_owner_id}"

priorityClassName: "platform-low"

resources:
  requests:
    cpu: 15m
    memory: 78Mi
