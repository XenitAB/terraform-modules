environment: ${environment}
clusterName: ${cluster_name}
cloudProvider: "${cloud_provider}"

remote:
  logsUrl:  "${remote_logs_url}"

client:
  key: "${client_key}"
  cert: "${client_cert}"

azureConfig:
  resourceID: "${azure_config.identity.resource_id}"
  clientID: "${azure_config.identity.client_id}"
  tenantID: "${azure_config.identity.tenant_id}"
  keyVaultName: "${azure_config.azure_key_vault_name}"

