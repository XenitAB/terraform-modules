cloudProvider: "azure"

image:
  tag: v1.24.0

autoDiscovery:
  clusterName: ${cluster_name}

containerSecurityContext:
 capabilities:
   drop:
   - ALL

priorityClassName: "platform-high"

resources:
  requests:
    cpu: 100m
    memory: 300Mi
  limits:
    memory: 600Mi

securityContext:
  runAsNonRoot: true
  runAsUser: 1001
  runAsGroup: 1001

extraArgs:
  skip-nodes-with-local-storage: false
