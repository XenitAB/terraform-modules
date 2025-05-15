apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: promtail
  namespace: promtail
spec:
  provider: "azure"
  parameters:
    clientID: ${client_id}
    keyvaultName: ${azure_config.azure_key_vault_name}
    tenantId: ${tenant_id}
    objects:  |
      array:
        - |
          objectName: "${azure_config.keyvault_secret_name}"
          objectType: secret
  secretObjects:
    - secretName: "${k8s_secret_name}"
      type: kubernetes.io/tls
      data:
        - objectName: "${azure_config.keyvault_secret_name}"
          key: tls.key
        - objectName: "${azure_config.keyvault_secret_name}"
          key: tls.crt
---
apiVersion: v1
kind: Service
metadata:
  name: promtail-metrics
  namespace: promtail
  labels:
    app.kubernetes.io/instance: promtail
    app.kubernetes.io/name: promtail
spec:
  clusterIP: None
  ports:
    - name: http-metrics
      port: 3101
      targetPort: http-metrics
      protocol: TCP
  selector:
    app.kubernetes.io/instance: promtail
    app.kubernetes.io/name: promtail