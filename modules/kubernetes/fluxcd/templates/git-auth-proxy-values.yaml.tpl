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
        %{if git_provider.github != null}
        "provider": "github",
        "github": {
          "appID": ${git_provider.github.app_id},
          "installationID": ${git_provider.github.installation_id},
          "privateKey": "${git_provider.github.private_key}"
        },
        "host": "github.com",
        %{endif}
        %{if git_provider.azure_devops != null}
        "provider": "azuredevops",
        "azuredevops": {
          "pat": "${git_provider.azure_devops.pat}"
        },
        "host": "dev.azure.com",
        %{endif}
        "name": "${git_provider.organization}",
        "repositories": [
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
