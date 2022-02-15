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
      cpu: 50m
      memory: 100Mi
    requests:
      cpu: 25m
      memory: 32Mi
