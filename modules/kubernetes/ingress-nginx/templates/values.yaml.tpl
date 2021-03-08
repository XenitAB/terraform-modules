controller:
  replicaCount: 3
  service:
    externalTrafficPolicy: Local
  config:
    server-tokens: "false"