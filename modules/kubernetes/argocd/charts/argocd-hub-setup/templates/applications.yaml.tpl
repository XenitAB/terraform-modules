{{- range .Values.azure_tenants }}
{{- $azure_tenant := . }}
{{- range .clusters }}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: '{{- $azure_tenant.tenant_name -}}-{{- .environment -}}-platform'
  namespace: '{{- $azure_tenant.tenant_name -}}-{{- .environment -}}'
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
spec:
 destination:
    namespace: '{{- $azure_tenant.tenant_name -}}-{{- .environment -}}'
    server: https://kubernetes.default.svc
  project: '{{- $azure_tenant.tenant_name -}}-{{- .environment -}}-platform'
  revisionHistoryLimit: 5
  source:'
    path: 'platform/{{- $azure_tenant.tenant_name -}}/{{- .name -}}'
    repoURL: '{{- .Values.fleet_infra_config.git_repo_url. }}'
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