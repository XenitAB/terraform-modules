apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-autoscaler-priority-expander
  namespace: kube-system
data:
  priorities: |-
    %{~ for prio,matches in priority_expander_config ~}
    ${prio}: ${matches}
    %{~ endfor ~}
