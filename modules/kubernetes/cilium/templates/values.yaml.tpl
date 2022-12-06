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

hostPort:
  enabled: true

nodePort:
  enabled: true

bpf:
  masquerade: true

kubeProxyReplacement: partial

externalIPs:
  enabled: true