apiVersion: v1
kind: Namespace
metadata:
 name: rabbitmq-system
 labels:
   name: rabbitmq
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: rabbitmq-operator
  namespace: rabbitmq-system
spec:
  interval: 1m0s
  type: oci
  url: "oci://registry-1.docker.io/bitnamicharts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: rabbitmq-operator
  namespace: rabbitmq-system
spec:
  chart:
    spec:
      chart: rabbitmq-cluster-operator
      sourceRef:
        kind: HelmRepository
        name: rabbitmq-operator
      version: 4.4.3
  interval: 1m0s
  values:
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