{{- $git_repo_url := .Values.git_repo_url }}
{{- range .Values.azure_tenants }}
{{- $azure_tenant := . }}
{{- range $azure_tenant.clusters }}
{{- $cluster := . }}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ printf "%s-%s-platform" $azure_tenant.tenant_name $cluster.environment }}
  namespace: {{ printf "%s-%s" $azure_tenant.tenant_name $cluster.environment }}
spec:
 destination:
    namespace: {{ printf "%s-%s" $azure_tenant.tenant_name $cluster.environment }}
    server: https://kubernetes.default.svc
  project: {{ printf "%s-%s-platform" $azure_tenant.tenant_name $cluster.environment }}
  revisionHistoryLimit: 5
  source:
    path: {{ printf "platform/%s/%s" $azure_tenant.tenant_name $cluster.name }}
    repoURL: {{ $git_repo_url }}
    targetRevision: HEAD
  automated:
    prune: false
    selfHeal: true
  syncPolicy:
    syncOptions:
      - RespectIgnoreDifferences=true
      - ApplyOutOfSyncOnly=true
---
{{- end }}
{{- end }}  