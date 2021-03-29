controller:
  replicaCount: 3
  service:
    externalTrafficPolicy: Local
  config:
    server-tokens: "false"
    %{ if http_snipet != "" }
    http-snippet: |
      ${http_snipet}
    %{ endif }