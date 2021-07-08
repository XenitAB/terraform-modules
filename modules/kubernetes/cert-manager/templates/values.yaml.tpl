installCRDs: true

global:
  priorityClassName: "platform-low"

%{ if provider == "azure" }
podLabels:
  aadpodidbinding: cert-manager
%{ endif }
%{ if provider == "aws" }
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "${aws_config.role_arn}"
securityContext:
  fsGroup: 1001
# This has to be enabled because when using Calico
# EKS will not be able to reach the webhook service.
# https://cert-manager.io/docs/concepts/webhook/#webhook-connection-problems-on-aws-eks
webhook:
  hostNetwork: true
%{ endif }
