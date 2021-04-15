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

%{ if internal_load_balancer }
service:
  annotations:
    "service.beta.kubernetes.io/${provider}-load-balancer-internal": "true"
%{ endif }
