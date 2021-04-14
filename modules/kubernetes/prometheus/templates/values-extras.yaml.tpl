# Default values for prometheus-extras.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

remoteWrite:
  enabled: ${remote_write_enabled}
  url: ${remote_write_url}
  tlsSecretName: ${remote_tls_secret_name}

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
