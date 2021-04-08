controller:
  replicaCount: 3
  service:
    externalTrafficPolicy: Local
  config:
    server-tokens: "false"
    %{ if http_snippet != "" }
    http-snippet: |
      ${http_snippet}
    %{ endif }