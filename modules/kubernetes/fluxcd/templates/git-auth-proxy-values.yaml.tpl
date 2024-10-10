priorityClassName: "platform-medium"
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
        %{if git_provider.type == "github"}
        "provider": "github",
        "github": {
          "appID": ${git_provider.github.app_id},
          "installationID": ${git_provider.github.installation_id},
          "privateKey": "${git_provider.github.private_key}"
        },
        "host": "github.com",
        %{endif}
        %{if git_provider.type == "azuredevops"}
        "provider": "azuredevops",
        "azuredevops": {
          "pat": "${git_provider.azure_devops.pat}"
        },
        "host": "dev.azure.com",
        %{endif}
        "name": "${git_provider.organization}",
        "repositories": [
          %{ for tenant in tenants ~}
          {
            "project": "${tenant.fluxcd.project}",
            "name": "${tenant.fluxcd.repository}",
            "namespaces": ["${tenant.name}"],
            "secretNameOverride": "flux"
          },
          %{ endfor }
          {
            "project": "${bootstrap.project}",
            "name": "${bootstrap.repository}",
            "namespaces": ["flux-system"],
            "secretNameOverride": "flux-system"
          }
        ]
      }
    ]
  }
