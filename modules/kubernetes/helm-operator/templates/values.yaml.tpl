allowNamespace: "${namespace}"
clusterRole:
  create: false
helm:
  versions: "v3"
configureRepositories:
  enable: true
  repositories:
    - name: "AzureContainerRegistry"
      url: "https://${acr_name}.azurecr.io/helm/v1/repo/"
      username: "${helm_operator_credentials.client_id}"
git:
  config:
    secretName: "helm-operator-git-config"

containerSecurityContext:
  helmOperator:
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    capabilities:
      drop:
        - NET_RAW

extraVolumeMounts:
  - name: tmp
    mountPath: /tmp
extraVolumes:
  - name: tmp
    emptyDir: {}
