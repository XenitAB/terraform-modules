allowNamespace: "${namespace}"
clusterRole:
  create: false
helm:
  versions: "v3"
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
