apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: logs-external-dns
  labels:
    xkf.xenit.io/kind: platform
rules:
  - verbs:
      - list
      - view
      - logs
    apiGroups:
      - ''
    resources:
      - pods
---
%{ for group in aad_groups ~}
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${group.namespace}-logs-external-dns
  namespace: external-dns
  labels:
    aad-group-name: ${group.name}
    xkf.xenit.io/kind: platform
subjects:
  - kind: Group
    apiGroup: rbac.authorization.k8s.io
    name: ${group.id}
    namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: logs-external-dns
---
%{ endfor }
---
apiVersion: v1
kind: Secret
metadata:
  name: external-dns-azure
  namespace: external-dns
data:
  azure.json: >-
    ${base64encode(<<EOT
{
"tenantId": "${tenant_id}",
"subscriptionId": "${subscription_id}",
"resourceGroup": "${resource_group}",
"useWorkloadIdentityExtension": true
}
EOT
)}
type: Opaque
