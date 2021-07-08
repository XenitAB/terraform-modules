cloudProvider: ${provider}

autoDiscovery:
  clusterName: ${cluster_name}

awsRegion: ${aws_region}

containerSecurityContext:
 capabilities:
   drop:
   - ALL

priorityClassName: "platform-medium"

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
