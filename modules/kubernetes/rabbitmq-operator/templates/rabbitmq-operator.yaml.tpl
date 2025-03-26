apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: rabbitmq-operator
  namespace: ${tenant_name}-${environment}
  annotations:
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
    repoURL: registry-1.docker.io/bitnamicharts
    targetRevision: 4.4.3
    chart: rabbitmq-cluster-operator
    helm:
      valuesObject:
        clusterOperator:
          replicaCount: ${replica_count}
          watchNamespaces:
%{ for ns in watch_namespaces ~}
          - ${ns}
%{ endfor }
          pdb:
            create: ${min_available > 0}
            minAvailable: ${min_available}
          %{ if spot_instances_enabled }
          tolerations:
          - key: kubernetes.azure.com/scalesetpriority
            operator: Exists
            effect: NoSchedule
          %{ endif }
          networkPolicy:
            enabled: ${network_policy_enabled}
          rbac:
            create: true
        msgTopologyOperator:
          enabled: ${tology_operator_enabled}