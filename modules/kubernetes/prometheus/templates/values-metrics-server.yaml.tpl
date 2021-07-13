# For more values: https://github.com/bitnami/charts/blob/master/bitnami/metrics-server/values.yaml

extraArgs:
  cert-dir: /tmp
  kubelet-preferred-address-types: "InternalIP,ExternalIP,Hostname"
  metric-resolution: 15s
  kubelet-use-node-status-port:

rbac:
  create: true

hostNetwork: true

apiService:
  create: true
