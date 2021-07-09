nameOverride: ${name_override}

controller:
  replicaCount: 3

  priorityClassName: platform-medium

  ingressClass: ${ingress_class}

  %{ if provider == "aws" }
  # Optionally change this to ClusterFirstWithHostNet in case you have 'hostNetwork: true'.
  # By default, while using host network, name resolution uses the host's DNS. If you wish nginx-controller
  # to keep resolving names inside the k8s network, use ClusterFirstWithHostNet.
  dnsPolicy: ClusterFirstWithHostNet
  hostNetwork: true
  %{ endif }

  service:
    externalTrafficPolicy: Local
    %{ if internal_load_balancer }
    annotations:
      service.beta.kubernetes.io/${provider}-load-balancer-internal: true
    %{ endif }

  config:
    server-tokens: "false"
    %{ if http_snippet != "" }
    http-snippet: |
      ${http_snippet}
    %{ endif }

  %{ if linkerd_enabled }
  podAnnotations:
    linkerd.io/inject: "ingress"
    # It's required to skip inbound ports for the ingress or whitelist of IPs won't work:
    # https://github.com/linkerd/linkerd2/issues/3334#issuecomment-565135188
    config.linkerd.io/skip-inbound-ports: "80,443"
  %{ endif }

  metrics:
    enabled: true
