apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: eck-operator
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: eck-system
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://helm.elastic.co
    targetRevision: 2.16.1
    chart: eck-operator
    helm:
      valuesObject:
        managedNamespaces:
%{ for ns in eck_managed_namespaces ~}
        - ${ns}
%{ endfor }
