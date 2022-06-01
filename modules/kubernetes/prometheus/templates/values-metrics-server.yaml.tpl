# For more values: https://github.com/bitnami/charts/blob/master/bitnami/metrics-server/values.yaml

extraArgs:
  - --cert-dir=/tmp
  - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
  - --kubelet-use-node-status-port
  - --metric-resolution=15s

rbac:
  create: true

hostNetwork: true
securePort: 7443

apiService:
  create: true
