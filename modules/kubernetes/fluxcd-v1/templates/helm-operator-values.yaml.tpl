allowNamespace: "${namespace}"
clusterRole:
  create: false
helm:
  versions: "v3"
git:
  config:
    enabled: true
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
  - name: cache
    mountPath: /root/.cache
extraVolumes:
  - name: tmp
    emptyDir: {}
  - name: cache
    emptyDir: {}

resources:
  requests:
    cpu: 50m
    memory: 128Mi
  limits:
    memory: 628Mi
