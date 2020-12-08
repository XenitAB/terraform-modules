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
    capabilities:
      drop:
        - NET_RAW

extraVolumeMounts:
  - name: tmp
    mountPath: /tmp
  - name: cache
    mountPath: /root/.cache
extraVolumes:
  - name: tmp
    emptyDir: {}
  - name: cache
    emptyDir: {}
