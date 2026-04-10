apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-sysctls-${name}
  namespace: node-sysctls
spec:
  selector:
    matchLabels:
      app: node-sysctls-${name}
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: node-sysctls-${name}
    spec:
      serviceAccountName: default
      hostPID: true
%{ if length(keys(node_selector)) > 0 ~}
      nodeSelector:
%{ for key, value in node_selector ~}
        ${key}: ${value}
%{ endfor ~}
%{ endif ~}
%{ if length(tolerations) > 0 ~}
      tolerations:
%{ for toleration in tolerations ~}
        - key: ${toleration.key}
          operator: ${toleration.operator}
%{ if toleration.operator == "Equal" ~}
          value: "${toleration.value}"
%{ endif ~}
          effect: ${toleration.effect}
%{ endfor ~}
%{ endif ~}
      containers:
        - name: sysctl
          image: dhi/busybox:1.37.0-debian13
          imagePullPolicy: IfNotPresent
          command:
            - sh
            - -c
            - |
%{ for key, value in sysctls ~}
              sysctl -w ${key}=${value}
%{ endfor ~}
              while true; do sleep 3600; done
          securityContext:
            privileged: true
            runAsUser: 0
            allowPrivilegeEscalation: true
          resources:
            requests:
              cpu: 10m
              memory: 16Mi
            limits:
              cpu: 100m
              memory: 64Mi

