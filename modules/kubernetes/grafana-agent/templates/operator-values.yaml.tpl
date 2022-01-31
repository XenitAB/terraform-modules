resources:
  requests:
    cpu: 25m
    memory: 100Mi
tolerations:
  - operator: "Exists"

kubeletService:
  namespace:  ${namespace}
