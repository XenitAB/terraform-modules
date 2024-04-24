apiVersion: mutations.gatekeeper.sh/v1beta1
kind: ModifySet
metadata:
  name: remove-azure-node-spot-taints
spec:
  location: "spec.taints"
  applyTo:
    - groups: [""]
      kinds: ["Node"]
      versions: ["v1"]
  parameters:
    operation: prune
    values:
      fromList:
        - effect: NoSchedule
          key: kubernetes.azure.com/scalesetpriority
          value: spot