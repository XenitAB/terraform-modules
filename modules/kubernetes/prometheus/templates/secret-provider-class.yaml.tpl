apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: prometheus
  namespace: prometheus
spec:
  provider: "azure"
  parameters:
    usePodIdentity: "true"
    keyvaultName: ${azure_config.azure_key_vault_name}
    objects:  |
      array:
        - |
          objectName: xenit-proxy-certificate
          objectType: secret
    tenantId: ${azure_config.azure_key_vault_name}
  secretObjects:
    - secretName: xenit-proxy-certificate
      type: kubernetes.io/tls
      data:
        - objectName: xenit-proxy-certificate
          key: tls.key
        - objectName: xenit-proxy-certificate
          key: tls.crt
