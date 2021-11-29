cloudProvider: "${cloud_provider}"

azureConfig:
  resourceID: "${azure_config.identity.resource_id}"
  clientID: "${azure_config.identity.client_id}"
  tenantID: "${azure_config.identity.tenant_id}"
  keyVaultName: "${azure_config.azure_key_vault_name}"

awsConfig:
  roleARN: "${aws_config.role_arn}"

volumeClaim:
  storageClassName: ${volume_claim_storage_class_name}
  size: ${volume_claim_size}

remoteWrite:
  authenticated: ${remote_write_authenticated}
  url: ${remote_write_url}
  headers:
    THANOS-TENANT: ${tenant_id}

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

enabledMonitors:
  falco: ${falco_enabled}
  opaGatekeeper: ${opa_gatekeeper_enabled}
  linkerd: ${linkerd_enabled}
  flux: ${flux_enabled}
  aadPodIdentity: ${aad_pod_identity_enabled}
  csiSecretsStorProviderAzure: ${csi_secrets_store_provider_azure_enabled}
  csiSecretsStorProviderAws: ${csi_secrets_store_provider_aws_enabled}
  azadKubeProxy: ${azad_kube_proxy_enabled}
