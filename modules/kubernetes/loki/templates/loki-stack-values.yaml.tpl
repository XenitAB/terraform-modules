loki: 
  enabled: true
promtail:
  enabled: false
grafana:
  enabled: true
  grafana.ini:
    auth.anonymous:
      enabled: "true"
      org_role: "Admin"
fluent-bit:
  enabled: true