{{- $secrets := dict }}
{{- range .Values.secrets }}
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
  name: {{ printf "repo-%s-%s-%s" $azure_tenant.tenant_name $cluster.environment .name }}
  labels:
    argocd.argoproj.io/secret-type: repository
type: Opaque
data:
  name: {{ printf "%s-%s-%s" $azure_tenant.tenant_name $cluster.environment .name | b64enc }}
  type: Z2l0
  url: {{ .repo_url | b64enc }}
  githubAppID: {{ .github_app_id | b64enc }}
  githubAppInstallationID: {{ .github_installation_id | b64enc }}
  githubAppPrivateKey: {{ get $secrets .secret_name | b64enc }}
---
{{- end }}
{{- end }}
{{- end }}