linux:
  priorityClassName: platform-high
  tolerations:
    - operator: Exists
  resources:
    requests:
      cpu: 30m
      memory: 50Mi
    limits:
      cpu: null
      memory: 100Mi

secrets-store-csi-driver:
  enableSecretRotation: true
  syncSecret:
    enabled: true
  linux:
    priorityClassName: platform-high
    metricsAddr: ":8081"
    tolerations:
      - operator: Exists

