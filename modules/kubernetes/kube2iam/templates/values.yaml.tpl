extraArgs:
  namespace-restrictions: true

host:
  ip: $(HOST_IP)
  # https://github.com/jtblin/kube2iam#iptables
  iptables: true
  # Use calico
  interface: cali+
  port: 8181

prometheus:
  # Port to expose the /metrics endpoint on. If unset, defaults to `host.port`
  # metricsPort: 9543
  service:
    enabled: true

  serviceMonitor:
    # Create prometheus-operator ServiceMonitor
    enabled: false

priorityClassName: "platform-high"

rbac:
  ## If true, create & use RBAC resources
  ##
  create: true
