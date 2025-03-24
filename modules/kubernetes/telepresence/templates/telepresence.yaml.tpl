apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: telepresence
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "3"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: ambassador
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
    repoURL: https://app.getambassador.io
    targetRevision: v2.18.1
    chart: telepresence
    helm:
      valuesObject:
        client:
          %{ if length(telepresence_config.allow_conflicting_subnets) > 0 }
          allowConflictingSubnets: 
          %{ for subnet in telepresence_config.allow_conflicting_subnets }
          - ${subnet}
          %{ endfor }
          %{ endif }
          connectionTTL: 12h
        clientRbac:
          create: ${ telepresence_config.client_rbac.create }
          %{ if length(telepresence_config.client_rbac.subjects) > 0 }
          subjects:
          %{ for subject in telepresence_config.client_rbac.subjects }
          - kind: Group
            name: ${subject}
            apiGroup: rbac.authorization.k8s.io
          %{ endfor }
          %{ endif }
          namespaced: ${ telepresence_config.client_rbac.namespaced }
          %{ if length(telepresence_config.client_rbac.namespaces) > 0 }
          namespaces:
          - ambassador
          %{ for ns in telepresence_config.client_rbac.namespaces }
          - ${ns}
          %{ endfor }
          %{ endif }
        managerRbac:
          create: ${ telepresence_config.manager_rbac.create }
          namespaced: ${ telepresence_config.manager_rbac.namespaced }
          %{ if length(telepresence_config.manager_rbac.namespaces) > 0 }
          namespaces:
          - ambassador
          %{ for ns in telepresence_config.manager_rbac.namespaces }
          - ${ns}
          %{ endfor }
          %{ endif }
