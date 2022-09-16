cloudProvider: "${cloud_provider}"

azureConfig:
  resourceID: "${azure_config.identity.resource_id}"
  clientID: "${azure_config.identity.client_id}"
  tenantID: "${azure_config.identity.tenant_id}"
  keyVaultName: "${azure_config.azure_key_vault_name}"
  hostnameKeyVaultSecretName: ${azure_config.hostname_key_vault_secret_name}"
  topicKeyVaultSecretName: "${topic_key_vault_secret_name}"
  connectionStringKeyVaultSecretName: "${connection_string_key_vault_secret_name}"
