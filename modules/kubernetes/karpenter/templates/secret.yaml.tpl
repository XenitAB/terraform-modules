apiVersion: v1
kind: Secret
metadata:
  name: kubelet-bootstrap-token
  namespace: kube-system
type: Opaque
data:
  KUBELET_BOOTSTRAP_TOKEN: ${bootstrap_token}