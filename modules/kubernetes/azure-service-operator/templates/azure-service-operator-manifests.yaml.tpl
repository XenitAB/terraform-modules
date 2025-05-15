apiVersion: v1
kind: Secret
metadata:
  name: aso-credential
  namespace: ${tenant_namespace}
stringData:
  AZURE_SUBSCRIPTION_ID: ${subscription_id}
  AZURE_TENANT_ID: ${tenant_id}
  AZURE_CLIENT_ID: ${client_id}