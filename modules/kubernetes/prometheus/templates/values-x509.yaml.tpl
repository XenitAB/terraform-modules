secretsExporter:
  includeNamespaces:
    - ${prometheus_namespace}
  priorityClassName: platform-medium

prometheusRules:
  # We don't manage prometheus rules per cluster.
  create: false

prometheusServiceMonitor:
  # We use serviceMonitors from another helm chart.
  create: false
