{{- range .Values.azure_tenants }}
{{- $azure_tenant := . }}
{{- range .clusters }}
{{- $cluster := . }}
{{- if ne $cluster.api_server "https://kubernetes.default.svc"}}
apiVersion: v1
kind: Secret
metadata:
  name: 'cluster-{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}'
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: '{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}'
  server: '{{- $cluster.api_server }}'
  config: |
    {
      "execProviderConfig": {
        "command": "argocd-k8s-auth",
        "env": {
          "AAD_ENVIRONMENT_NAME": "AzurePublicCloud",
          "AZURE_CLIENT_ID": {{- $cluster.azure_client_id | quote }},
          "AZURE_TENANT_ID": {{- $azure_tenant.tenant_id | quote }},
          "AZURE_FEDERATED_TOKEN_FILE": "/var/run/secrets/tokens/{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}-federated-token-file",
          "AZURE_AUTHORITY_HOST": "https://login.microsoftonline.com/",
          "AAD_LOGIN_METHOD": "workloadidentity"
        },
        "args": ["azure"],
        "apiVersion": "client.authentication.k8s.io/v1beta1"
      },
      "tlsClientConfig": {
        "insecure": false,
        "caData": {{- $cluster.ca_data | quote }}
      }
    }
---
{{- end }}
{{- end }}
{{- end }}  