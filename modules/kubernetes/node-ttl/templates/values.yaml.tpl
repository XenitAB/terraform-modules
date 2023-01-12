resources:
  requests:
    cpu: 5m
    memory: 20Mi
  limits:
    memory: 50Mi
nodeTtl:
  statusConfigMapNamespace: ${status_config_map_namespace}
