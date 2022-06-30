cloudProvider: ${provider}

autoDiscovery:
  clusterName: ${cluster_name}

containerSecurityContext:
 capabilities:
   drop:
   - ALL

priorityClassName: "platform-high"

resources:
  requests:
    cpu: 10m
    memory: 100Mi
  limits:
    memory: 300Mi

securityContext:
  runAsNonRoot: true
  runAsUser: 1001
  runAsGroup: 1001

%{ if provider == "aws" }
awsRegion: ${aws_config.region}
rbac:
  serviceAccount:
    name: "cluster-autoscaler"
    annotations:
      eks.amazonaws.com/role-arn: ${aws_config.role_arn}
%{ endif }

extraArgs:
  skip-nodes-with-local-storage: false
  skip-nodes-with-system-pods: false
  scale-down-unneeded-time: 5m
  expander: least-waste

image:
  tag: ${tag}
