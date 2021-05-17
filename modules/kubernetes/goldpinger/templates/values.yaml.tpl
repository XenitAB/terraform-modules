goldpinger:
  port: 8080

priorityClassName: "system-node-critical"

%{ if linkerd_enabled }
podAnnotations:
  linkerd.io/inject: enabled
%{ endif }
