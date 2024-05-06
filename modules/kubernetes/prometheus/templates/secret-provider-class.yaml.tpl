apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: prometheus
  namespace: prometheus
spec:
  provider: "azure"
  parameters:
    clientID: ${client_id}
    keyvaultName: ${azure_key_vault_name}
    tenantId: ${tenant_id}
    objects:  |
      array:
        - |
          objectName: xenit-proxy-certificate
          objectType: secret
  secretObjects:
    - secretName: xenit-proxy-certificate
      type: kubernetes.io/tls
      data:
        - objectName: xenit-proxy-certificate
          key: tls.key
        - objectName: xenit-proxy-certificate
          key: tls.crt
