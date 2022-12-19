secretsExporter:
  includeNamespaces:
    - ${prometheus_namespace}

prometheusRules:
  # -- Should a PrometheusRule ressource be installed to alert on certificate expiration. For prometheus-operator (kube-prometheus) users.
  create: false

prometheusServiceMonitor:
  # -- Should a ServiceMonitor ressource be installed to scrape this exporter. For prometheus-operator (kube-prometheus) users.
  create: false
