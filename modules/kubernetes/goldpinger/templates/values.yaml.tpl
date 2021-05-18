goldpinger:
  port: 8080

priorityClassName: "critical"

%{ if linkerd_enabled }
podAnnotations:
  linkerd.io/inject: enabled
%{ endif }
