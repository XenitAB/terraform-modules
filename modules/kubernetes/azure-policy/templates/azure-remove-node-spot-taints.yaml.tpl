apiVersion: mutations.gatekeeper.sh/v1beta1
kind: ModifySet
metadata:
  name: remove-azure-node-spot-taints
spec:
  match:
    scope: Cluster
    kinds:
      - apiGroups: [""]
        kinds: ["Node"]
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
