aksbyocni:
  enabled: true

prometheus:
  enabled: true

operator:
  prometheus:
    enabled: true

hubble:
  enabled: true
  metrics:
    enabled:
      - dns:query;ignoreAAAA
      - drop
      - tcp
      - flow
      - icmp
      - http

  relay:
    enabled: true
    prometheus:
      enabled: true
    priorityClassName: platform-medium

  ui:
    enabled: true
    priorityClassName: platform-medium

kubeProxyReplacement: strict
k8sServiceHost: ${k8s_service_host}
k8sServicePort: ${k8s_service_port}
localRedirectPolicy: true

nodePort:
  # -- Enable the Cilium NodePort service implementation.
  enabled: true

hostPort:
  # -- Enable hostPort service support.
  enabled: true

externalIPs:
  # -- Enable ExternalIPs service support.
  enabled: true
