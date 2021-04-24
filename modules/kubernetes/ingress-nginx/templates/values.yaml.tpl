nameOverride: ${name_override}

controller:
  replicaCount: 3

  ingressClass: ${ingress_class}

  service:
    externalTrafficPolicy: Local
    %{ if internal_load_balancer }
    annotations:
      service.beta.kubernetes.io/${provider}-load-balancer-internal: true
    %{ endif }

  config:
    server-tokens: "false"
    %{ if http_snippet != "" }
    http-snippet: |
      ${http_snippet}
    %{ endif }

  metrics:
    enabled: true
