reloader:
  serviceMonitor:
    enabled: ${prometheus_enabled}
    labels:
      xkf.xenit.io/monitoring: platform
