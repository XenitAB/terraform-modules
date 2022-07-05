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
  resources:
    limits:
      cpu: 100m
      memory: 300Mi
    requests:
      cpu: 60m
      memory: 200Mi
