apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: telepresence
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/compare-options: IncludeMutationWebhook=true
    argocd.argoproj.io/manifest-generate-paths: .
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
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  ignoreDifferences:
  - group: admissionregistration.k8s.io
    kind: MutatingWebhookConfiguration
    name: agent-injector-webhook-ambassador
    jqPathExpressions:
    - .webhooks[].namespaceSelector.matchExpressions[] | select(.key == "control-plane")
    - .webhooks[].namespaceSelector.matchExpressions[] | select(.key == "kubernetes.azure.com/managedby")
  source:
    repoURL: https://app.getambassador.io
    targetRevision: v2.18.1
    chart: telepresence
    helm:
      releaseName: traffic-manager
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
