resources:
  requests:
    cpu: 25m
    memory: 80Mi
  limits:
    memory: 256Mi

kubeletService:
  namespace:  ${namespace}
