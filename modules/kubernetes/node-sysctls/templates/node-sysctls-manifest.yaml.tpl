apiVersion: v1
kind: Namespace
metadata:
  name: node-sysctls
  labels:
    xkf.xenit.io/kind: platform
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-sysctls
  namespace: node-sysctls
spec:
  selector:
    matchLabels:
      app: node-sysctls
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: node-sysctls
    spec:
      serviceAccountName: default
      hostPID: true
%{ if length(keys(node_selector)) > 0 ~}
      nodeSelector:
${indent(8, yamlencode(node_selector))}
%{ endif ~}
      tolerations:
${indent(8, yamlencode(concat([
  {
    key      = "CriticalAddonsOnly"
    operator = "Exists"
  }
], [for toleration in tolerations : {
  for key, value in toleration : key => value if value != null
}]))) }
      containers:
        - name: sysctl
          image: busybox:1.36
          imagePullPolicy: IfNotPresent
          command:
            - sh
            - -c
            - |
              sysctl -w vm.max_map_count=${vm_max_map_count}
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

