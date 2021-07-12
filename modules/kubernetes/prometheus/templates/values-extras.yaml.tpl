# Default values for prometheus-extras.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

remoteWrite:
  enabled: ${remote_write_enabled}
  url: ${remote_write_url}
  %{ if tenant_id != "" }
  headers:
    THANOS-TENANT: ${tenant_id}
  %{ endif }

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

alertmanager:
  enabled: ${alertmanager_enabled}
  ruleSelector:
    matchExpressions:
      - key: xkf.xenit.io/monitoring
        operator: In
        values: ${resource_selector}
      - key: xkf.xenit.io/rule
        operator: In
        values: [prometheus]
  ruleNamespaceSelector:
    matchExpressions:
      - key: xkf.xenit.io/kind
        operator: In
        values: ${namespace_selector}

enabledMonitors:
  falco: ${falco_enabled}
  opaGatekeeper: ${opa_gatekeeper_enabled}
  linkerd: ${linkerd_enabled}
  goldpinger: ${goldpinger_enabled}
  fluxSystem: ${flux_system_enabled}
  csiSecretsStorProviderAzure: ${csi_secrets_store_provider_azure_enabled}
