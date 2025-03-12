{{- $secrets := dict -}}
{{- range .Values.secrets -}}
{{- $_ := set $secrets .name .value -}}
{{- end -}}
{{- range .Values.clusters }}
{{- $cluster := . }}
{{- range .tenants }}
apiVersion: v1
kind: Secret
metadata:
  name: repo-{{- $.Values.tenant_name -}}-{{- $cluster.environment -}}-{{- .namespace -}}
  labels:
    argocd.argoproj.io/secret-type: repository
type: Opaque
data:
  name: '{{- $.Values.tenant_name -}}-{{- $cluster.environment -}}-{{- .namespace -}}'
  type: git
  url: '{{ .repo_url }}'
  username: git
  password: '{{- get $secrets .secret_name -}}'
---
{{- end }}
{{- end }}