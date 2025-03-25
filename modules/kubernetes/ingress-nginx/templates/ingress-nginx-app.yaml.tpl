apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${ingress_nginx_name}-app
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: https://kubernetes.default.svc
    namespace: ingress_nginx
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: ${repo_url}
    targetRevision: HEAD
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/ingress_nginx