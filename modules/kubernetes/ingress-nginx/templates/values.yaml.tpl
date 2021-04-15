controller:
  replicaCount: 3
  service:
    externalTrafficPolicy: Local
  config:
    server-tokens: "false"
    %{ if http_snippet != "" }
    http-snippet: |
      ${http_snippet}
    %{ endif }

nameOverride: ${name_override}
ingressClass: ${ingress_class}

%{ if provider == "aws" && internal_load_balancer }
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-internal
%{ endif }
