apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - "groups":
      - "system:bootstrappers"
      - "system:nodes"
      "rolearn": "${node_groups_role}"
      "username": "system:node:{{EC2PrivateDNSName}}"
    ${cluster_roles}
    ${namespace_roles}
