apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: argocd-clusteradmin
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: {{ .Values.uai_id }}
    namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin