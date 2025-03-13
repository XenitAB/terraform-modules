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
  name: 'repo-{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}-{{- .namespace -}}'
  labels:
    argocd.argoproj.io/secret-type: repository
type: Opaque
data:
  name: {{- printf "%s-%s-%s" $azure_tenant.tenant_name $cluster.environment .namespace | b64enc -}}
  type: Z2l0
  url: {{ .repo_url | b64enc }}
  username: Z2l0
  password: {{- get $secrets .secret_name | b64enc -}}
---
{{- end }}
{{- end }}
{{- end }}