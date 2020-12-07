allowNamespaces:
  - "${namespace}"

clusterRole:
  create: false

git:
  url: "${git_url}"
  path: "${environment}"
  readonly: true
  pollInterval: "30s"
  config:
    enabled: true
    secretName: "flux-git-config"

registry:
  disableScanning: true

memcached:
  enabled: false

syncGarbageCollection:
  enabled: true

containerSecurityContext:
  flux:
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
