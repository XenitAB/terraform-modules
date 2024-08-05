apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: grafana-alloy-secrets
  namespace: grafana-alloy
spec:
  provider: azure
  parameters:
    clientID: ${client_id}
    keyvaultName: ${key_vault_name}
    tenantId: ${tenant_id}
    objects: |
      array:
        - |
          objectName: grafana-cloud-api-key
          objectType: secret
  secretObjects:
    - secretName: grafana-cloud-api-key
      type: Opaque
      data:
        - objectName: grafana-cloud-api-key
          key: GRAFANA_CLOUD_API_KEY
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: grafana-alloy-secret-mount
  namespace: grafana-alloy
  annotations:
    azure.workload.identity/client-id: ${client_id}
