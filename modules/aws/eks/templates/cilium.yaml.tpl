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
    priorityClassName: system-cluster-critical

  ui:
    enabled: true
    priorityClassName: system-cluster-critical

localRedirectPolicy: true
kubeProxyReplacement: strict
k8sServiceHost: ${k8s_service_host}
k8sServicePort: ${k8s_service_port}

nodePort:
  enabled: true

hostPort:
  enabled: true

externalIPs:
  enabled: true
