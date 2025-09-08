apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: ${pool.name}
  annotations:
    kubernetes.io/description: "${pool.description}"
spec:
  disruption:
    consolidateAfter: ${pool.consolidate_after}
    expireAfter: ${pool.node_ttl}
     %{~ if length(pool.disruption_budgets) > 0 ~}
     budgets:
     %{~ for budget in pool.disruption_budgets ~}
     - nodes: "${budget.nodes}"
       %{~ if budget.duration != null ~}
       duration: ${budget.duration}
       %{~ endif ~}
       %{~ if budget.schedule != null ~}
       schedule: ${budget.schedule}
       %{~ endif ~}
       %{~ if length(budget.reasons) > 0 ~}
       reasons:
       %{~ for reason in budget.reasons ~}
       - ${reason}
       %{~ endfor ~}
       %{~ endif ~}
     %{~ endfor ~}
     %{~ endif ~}
  limits:
    cpu: ${pool.limits.cpu}
    memory: ${pool.limits.memory}
  template:
    metadata:
      labels:
        # required for Karpenter to predict overhead from cilium DaemonSet
        kubernetes.azure.com/ebpf-dataplane: cilium
        %{~ if length(pool.node_labels) > 0 ~}
        %{~ for key, value  in pool.node_labels ~}
        ${key} : ${value}
        %{~ endfor ~}
        %{~ endif ~}
      %{~ if length(pool.node_annotations) > 0 ~}
      annotations:
        %{~ for annotation in pool.node_annotations ~}
        ${annotation}
        %{~ endfor ~}
      %{~ endif ~}
    spec:
      startupTaints:
        # https://karpenter.sh/docs/concepts/nodepools/#cilium-startup-taint
        - key: node.cilium.io/agent-not-ready
          effect: NoExecute
          value: "true"
      %{~ if length(pool.node_taints) > 0 ~}
      taints: 
        %{~ for taint in pool.node_taints ~}
        - key: ${taint.key}
          effect: ${taint.effect}
          value: "${taint.value}"
        %{~ endfor ~}
      %{~ endif ~}
      requirements:
        %{~ for requirement in pool.node_requirements ~}
        - key: ${requirement.key}
          operator: ${requirement.operator}
          values: ${jsonencode(requirement.values)}
        %{~ endfor ~}
      nodeClassRef:
        name: ${pool.node_class_ref}
        kind: AKSNodeClass
        group: karpenter.azure.com

  weight: ${pool.weight}