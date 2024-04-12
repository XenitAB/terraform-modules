cloudProvider: "azure"

azureConfig:
  resourceID: "${azure_config.identity.resource_id}"
  clientID: "${azure_config.identity.client_id}"
  tenantID: "${azure_config.identity.tenant_id}"
  keyVaultName: "${azure_config.azure_key_vault_name}"
  hostname: "${azure_config.eventhub_hostname}"
  topic: "${azure_config.eventhub_name}"
