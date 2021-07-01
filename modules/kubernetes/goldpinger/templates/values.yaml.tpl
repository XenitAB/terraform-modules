goldpinger:
  port: 8080

priorityClassName: "platform-high"

%{ if linkerd_enabled }
podAnnotations:
  linkerd.io/inject: enabled
%{ endif }

service:
  type: ClusterIP
