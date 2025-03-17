apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: rabbitmq-operator
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: rabbitmq-system
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: oci://registry-1.docker.io/bitnamicharts
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