goldpinger:
  port: 8080

priorityClassName: "system-cluster-critical"

%{ if linkerd_enabled }
podAnnotations:
  linkerd.io/inject: enabled
%{ endif }
