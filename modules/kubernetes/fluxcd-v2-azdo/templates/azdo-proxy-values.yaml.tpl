image:
  tag: v0.4.0-rc1
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    memory: 256Mi
config: |
  {
    "organizations": [
      {
        "name": "${azure_devops_org}",
        "pat": "${azure_devops_pat}",
        "repositories": [
          %{ for tenant in tenants ~}
          {
            "project": "${tenant.project}",
            "name": "${tenant.repo}",
            "namespaces": ["${tenant.namespace}"]
          },
          %{ endfor }
          {
            "project": "${azure_devops_proj}",
            "name": "${cluster_repo}",
            "namespaces": ["flux-system"]
          }
        ]
      }
    ]
  }
