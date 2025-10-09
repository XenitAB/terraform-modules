apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: rabbitmq-operator
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "3"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: rabbitmq-system
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://github.com/rabbitmq/cluster-operator
    targetRevision: ${target_revision}
    path: .
  sources:
  - repoURL: https://github.com/rabbitmq/cluster-operator
    targetRevision: ${target_revision}
    ref: repo
  - repoURL: https://raw.githubusercontent.com/rabbitmq/cluster-operator/${target_revision}/cluster-operator.yml
    targetRevision: HEAD
