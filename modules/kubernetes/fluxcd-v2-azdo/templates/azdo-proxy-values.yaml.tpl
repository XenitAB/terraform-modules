image:
  tag: v0.3.6
replicaCount: 1
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    memory: 256Mi
config: |
  {
    "pat": "${azure_devops_pat}",
    "organization": "${azure_devops_org}",
    "repositories": [
      %{ for tenant in tenants ~}
      {
        "project": "${tenant.project}",
        "name": "${tenant.repo}",
        "token": "${tenant.token}"
      },
      %{ endfor }
      {
        "project": "${azure_devops_proj}",
        "name": "${cluster_repo}",
        "token": "${cluster_token}"
      }
    ]
  }
