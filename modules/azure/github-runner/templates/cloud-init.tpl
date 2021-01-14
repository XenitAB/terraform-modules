#cloud-config
write_files:
- content: |
    {
      "AZURE_KEYVAULT_NAME": "${azure_keyvault_name}",
      "GITHUB_ORGANIZATION_KVSECRET": "${github_organization_kvsecret}",
      "GITHUB_APP_ID_KVSECRET": "${github_app_id_kvsecret}",
      "GITHUB_INSTALLATION_ID_KVSECRET": "${github_installation_id_kvsecret}",
      "GITHUB_PRIVATE_KEY_KVSECRET": "${github_private_key_kvsecret}"
    }
  path: /etc/github-runner/github-runner-config.json
