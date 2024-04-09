global:
  priorityClassName: "platform-medium"

podLabels:
  azure.workload.identity/use: "true"
serviceAccount:
  labels:
    azure.workload.identity/use: "true"
webhook:
  resources:
    requests:
      cpu: 30m
      memory: 100Mi

requests:
  cpu: 15m
  memory: 150Mi

cainjector:
  resources:
    requests:
      cpu: 25m
      memory: 250Mi
