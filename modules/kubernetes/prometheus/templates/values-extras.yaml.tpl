# Default values for prometheus-extras.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

remoteWrite:
  enabled: ${remote_write_enabled}
  url: ${remote_write_url}
  headers:
    THANOS-TENANT: ${tenant_id}

volumeClaim:
  enabled: ${volume_claim_enabled}
  storageClassName: ${volume_claim_storage_class_name}
  size: ${volume_claim_size}

resources:
  requests:
    memory: "250Mi"
    cpu: "20m"
  limits:
    memory: "500Mi"

externalLabels:
  clusterName: ${cluster_name}
  environment: ${environment}

prometheus:
  resourceSelector:
    matchExpressions:
      - key: xkf.xenit.io/monitoring
        operator: In
        values: ${resource_selector}
  namespaceSelector:
    matchExpressions:
      - key: xkf.xenit.io/kind
        operator: In
        values: ${namespace_selector}
