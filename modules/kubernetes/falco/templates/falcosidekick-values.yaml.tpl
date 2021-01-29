config:
  datadog:
    host: "${datadog_host}"
    apikey: "${datadog_api_key}
    minimumpriority: "alert"

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    memory: 128Mi
