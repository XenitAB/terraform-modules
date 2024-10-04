apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azad-kube-proxy
  namespace: azad-kube-proxy
spec:
  provider: "azure"
  parameters:
    clientID: ${client_id}
    keyvaultName: ${key_vault_name}
    tenantId: ${tenant_id}
    objects:  |
      array:
        - |
          objectName: azad-kube-proxy-${environment}-${location_short}-${name}
          objectType: secret
  secretObjects:
    - secretName: azad-kube-proxy-${environment}-${location_short}-${name}
      type: Opaque
      data:
        - objectName: azad-kube-proxy-${environment}-${location_short}-${name}
          key: CLIENT_ID
        - objectName: azad-kube-proxy-${environment}-${location_short}-${name}
          key: CLIENT_SECRET
        - objectName: azad-kube-proxy-${environment}-${location_short}-${name}
          key: TENANT_ID
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: azad-kube-proxy
  namespace: azad-kube-proxy
  annotations:
    azure.workload.identity/client-id: ${client_id}