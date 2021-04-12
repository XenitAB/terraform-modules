installCRDs: true

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
%{ endif }

prometheus:
  enabled: ${prometheus_enabled}
  servicemonitor:
    enabled: ${prometheus_enabled}
    labels:
      xkf.xenit.io/monitoring: platform
