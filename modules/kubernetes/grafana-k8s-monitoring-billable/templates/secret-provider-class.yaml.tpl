apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: grafana-k8s-monitor-billable-secrets
  namespace: grafana-k8s-monitoring-billable
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
spec:
  provider: azure
  parameters:
    clientID: ${client_id}
    keyvaultName: ${key_vault_name}
    tenantId: ${tenant_id}
    objects: |
      array:
        - |
          objectName: prometheus-grafana-cloud-host
          objectType: secret
        - |
          objectName: prometheus-grafana-cloud-user
          objectType: secret
        - |
          objectName: prometheus-grafana-cloud-password
          objectType: secret
  secretObjects:
    - secretName: prometheus-grafana-cloud
      type: Opaque
      data:
        - objectName: prometheus-grafana-cloud-host
          key: host
        - objectName: prometheus-grafana-cloud-user
          key: username
        - objectName: prometheus-grafana-cloud-password
          key: password
        - objectName: prometheus-grafana-cloud-user
          key: tenantId
