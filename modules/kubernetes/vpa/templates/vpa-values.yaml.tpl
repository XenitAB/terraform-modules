priorityClassName: platform-medium

recommender:
  extraArgs:
    pod-recommendation-min-cpu-millicores: 15
    pod-recommendation-min-memory-mb: 24
  resources:
    limits:
      cpu: 200m
      memory: 500Mi
    requests:
      cpu: 50m
      memory: 250Mi

updater:
  enabled: false

admissionController:
  enabled: false

recommender:
  image:
    repository: registry.k8s.io/autoscaling/vpa-recommender
    pullPolicy: IfNotPresent
    tag: "0.12.0"
