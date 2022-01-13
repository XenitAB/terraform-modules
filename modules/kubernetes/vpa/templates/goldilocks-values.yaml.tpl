dashboard:
  enabled: false

controller:
  flags:
    on-by-default: "true"
    exclude-namespaces: "kube-system"
  rbac:
    extraRules:
      - apiGroups:
          - 'batch'
        resources:
          - '*'
        verbs:
          - 'get'
          - 'list'
          - 'watch'
