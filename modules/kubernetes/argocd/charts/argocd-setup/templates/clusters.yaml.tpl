{{- range .Values.clusters }}
apiVersion: v1
kind: Secret
metadata:
  name: {{- $.Values.tenant_name -}}-{{- .environment -}}-secret
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: {{- .name | quote }}
  server: {{- .api_server | quote }}
  config: |
    {
      "execProviderConfig": {
        "command": "argocd-k8s-auth",
        "env": {
          "AAD_ENVIRONMENT_NAME": "AzurePublicCloud",
          "AZURE_CLIENT_ID": {{- .azure_client_id | quote }},
          "AZURE_TENANT_ID": {{- .azure_tenant_id | quote }},
          "AZURE_FEDERATED_TOKEN_FILE": "/var/run/secrets/tokens/{{- $.Values.tenant_name }}-{{- .environment }}-federated-token-file",
          "AZURE_AUTHORITY_HOST": "https://login.microsoftonline.com/",
          "AAD_LOGIN_METHOD": "workloadidentity"
        },
        "args": ["azure"],
        "apiVersion": "client.authentication.k8s.io/v1beta1"
      },
      "tlsClientConfig": {
        "insecure": false,
        "caData": {{- .ca_data | quote }}
      }
    }
---
{{- end }} 
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: argocd-clusteradmin
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: {{- .Values.uaid_id -}}
    namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin