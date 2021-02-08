config:
  customfields: "source:falco,env:${environment}"
  datadog:
    host: "${datadog_host}"
    apikey: "${datadog_api_key}"
    minimumpriority: "${minimum_priority}"
