priorityClassName: "platform-medium"
networkPolicy:
  enabled: true
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
        "provider": "github",
        "github": {
          "appID": ${app_id},
          "installationID": ${installation_id},
          "privateKey": "${private_key}"
        },
        "host": "github.com",
        "name": "${github_org}",
        "repositories": [
          %{ for tenant in tenants ~}
          {
            "project": "foo",
            "name": "${tenant.repo}",
            "namespaces": ["${tenant.namespace}"],
            "secretNameOverride": "flux"
          },
          %{ endfor }
          {
            "project": "foo",
            "name": "${cluster_repo}",
            "namespaces": ["flux-system"],
            "secretNameOverride": "flux-system"
          }
        ]
      }
    ]
  }
