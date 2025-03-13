{{- $secrets := dict }}
{{- range .Values.secret_names }}
{{- $_ := set $secrets  .name .value }}
{{- end }}
{{- range .Values.azure_tenants }}
{{- $azure_tenant := . }}
{{- range .clusters }}
{{- $cluster := . }}
{{- range .tenants }}
apiVersion: v1
kind: Secret
metadata:
  name: repo-{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}-{{- .namespace -}}
  labels:
    argocd.argoproj.io/secret-type: repository
type: Opaque
data:
  name: '{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}-{{- .namespace -}}'
  type: git
  url: '{{ .repo_url }}'
  username: git
  password: '{{- get $secrets .secret_name -}}'
---
{{- end }}
{{- end }}
{{- end }}