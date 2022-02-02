resources:
  requests:
    cpu: 25m
    memory: 80Mi
  limits:
    memory: 120Mi

kubeletService:
  namespace:  ${namespace}
