aksbyocni:
  enabled: true

prometheus:
  enabled: true
  serviceMonitor:
    enabled: true
    labels:
      xkf.xenit.io/monitoring: platform

operator:
  prometheus:
    enabled: true
    serviceMonitor:
      enabled: true
      labels:
        xkf.xenit.io/monitoring: platform

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